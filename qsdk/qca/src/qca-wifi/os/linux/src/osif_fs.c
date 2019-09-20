/*
* Copyright (c) 2015-2016 Qualcomm Atheros, Inc.
* All Rights Reserved.
* Qualcomm Atheros Confidential and Proprietary.
*/

/**
 * DOC: osif_fs.c
 * This file provides OS dependent filesystem API's.
 */

#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/types.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include <osif_fs.h>
#include <qdf_status.h>
#include <qdf_trace.h>

/**
 * qdf_fs_read - a file operation of a kerenl and system
 * @filename: name of file
 * @offset: offset to read file from
 * @size: size of the buffer
 * @buffer: buffer to fill
 *
 * Returns: int
 */
int __ahdecl qdf_fs_read(char *filename,
				loff_t offset,
				unsigned int size,
				unsigned char *buffer)
{
	struct file      *filp;
	struct inode     *inode;
	unsigned long    magic;
	off_t            fsize;
	mm_segment_t     fs;
	ssize_t		ret;

	if (NULL == buffer) {
		QDF_TRACE(QDF_MODULE_ID_QDF, QDF_TRACE_LEVEL_ERROR,
			  "%s[%d], Error, null pointer to buffer.\n", __func__,
				__LINE__);
		return QDF_STATUS_E_FAILURE;
	}

	filp = filp_open(filename, O_RDONLY, 0);
	if (IS_ERR(filp)) {
		QDF_TRACE(QDF_MODULE_ID_QDF, QDF_TRACE_LEVEL_ERROR,
			  "%s[%d]: Fail to Open File %s\n", __func__,
				 __LINE__, filename);
		return QDF_STATUS_E_FAILURE;
	}
	QDF_TRACE(QDF_MODULE_ID_QDF, QDF_TRACE_LEVEL_INFO,
		  "%s[%d], Open File %s SUCCESS!!\n", __func__,
				__LINE__, filename);

#if LINUX_VERSION_CODE < KERNEL_VERSION(3,19,0)
	inode = filp->f_dentry->d_inode;
#else
	inode = filp->f_path.dentry->d_inode;
#endif
	fsize = inode->i_size;
	magic = inode->i_sb->s_magic;
	QDF_TRACE(QDF_MODULE_ID_QDF, QDF_TRACE_LEVEL_INFO, "file_info: magic=%ld, blocksize=%ld, inode=%ld, size=%d\n", magic, inode->i_sb->s_blocksize, inode->i_ino, (unsigned int)fsize);
	if (fsize != size) {
		QDF_TRACE(QDF_MODULE_ID_QDF, QDF_TRACE_LEVEL_ERROR,
			  "%s[%d]: caldata data size mismatch, fsize=%d, cal_size=%d\n",
		__func__, __LINE__, (unsigned int)fsize, size);

		if (size > fsize) {
			QDF_TRACE(QDF_MODULE_ID_QDF, QDF_TRACE_LEVEL_ERROR,
				  "%s[%d], exit with error: size > fsize\n",
			__func__, __LINE__);
			filp_close(filp, NULL);
			return QDF_STATUS_E_FAILURE;
		}
	}
	fs = get_fs();
	filp->f_pos = offset;
	set_fs(KERNEL_DS);
	ret = vfs_read(filp, buffer, size, &(filp->f_pos));
	set_fs(fs);
	filp_close(filp, NULL);

	if (ret < 0) {
		QDF_TRACE(QDF_MODULE_ID_QDF, QDF_TRACE_LEVEL_ERROR,
			  "%s[%d]: Fail to Read File %s: %d\n", __func__,
				 __LINE__, filename, ret);

		return QDF_STATUS_E_FAILURE;
	}
	return QDF_STATUS_SUCCESS;
}
EXPORT_SYMBOL(qdf_fs_read);
