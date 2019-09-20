/*
 * Copyright (c) 2017 Qualcomm Technologies, Inc.
 *
 * All Rights Reserved.
 * Confidential and Proprietary - Qualcomm Technologies, Inc.

*/

#ifndef wifison_event__h /*once only*/
#define wifison_event__h

/*====================================================================*"
 *   system header files;
 *--------------------------------------------------------------------*/


#define SONE_EVENT_SOCKET_CLIENT       "/var/run/sonevent_socket_client"
#define SONE_EVENT_SOCKET_SERVER       "/var/run/sonevent_socket_server"
#define MESSAGE_FRAME_LEN_MAX    20480

#define VENDOR_DATA_LEN_MAX      1482

typedef enum {
    false = 0,
    true = 1,
} bool;

enum sonEventSockMsgType
{
    SERVER_START,
    CLIENT_START,
    EVENT_REGISTER,
    EVENT_DEREGISTER,
    SERVER_STOP,
    VENDOR_DATA_SEND,
    EVENT_NOTIFICATION,
};

enum sonEventRegisterID
{
    SON_RE_JOIN_EVENT,
    SON_RE_LEAVE_EVENT,
    SON_DATA_EVENT,
    SON_HYD_RESTART_EVENT,
    SON_MAX_EVENT,
};

enum sonEventStatus
{
    EVENT_OK,
    EVENT_NO_DATA,
    EVENT_SOCKET_ERROR,
};

struct service_message {
    unsigned int cmd;
    unsigned int len;
    unsigned char data[1];
} __attribute__ ((packed));

struct reInfo {
    unsigned char macaddress[6];
    unsigned char isDistantNeighbor;
} __attribute__ ((packed));

struct vendorData {
    unsigned char macaddress[6];
    unsigned char cus_data[VENDOR_DATA_LEN_MAX];
} __attribute__ ((packed));

struct sonEventInfo {
    int eventMsg;
    int length;
    union {
        struct reInfo re;
        struct vendorData vdata;
    } data;
} __attribute__ ((packed));

int wifison_event_init(void);
void wifison_event_deinit(void);
void wifison_event_register(int);
void wifison_event_deregister(int);
int wifison_event_get(struct sonEventInfo *event);
void wifison_data_send(struct vendorData *vData, int vDataLen);
#endif
