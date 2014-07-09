


#define DEBUG_LOG 0
#if DEBUG_LOG
#define DFLOG(...) NSLog(__VA_ARGS__)
#define XBLOG(...) NSLog(__VA_ARGS__)
#define VDLOG(...) NSLog(__VA_ARGS__)
#else
#define DFLOG(...) do{}while(0)
#define XBLOG(...) do{}while(0)
#define VDLOG(...) do{}while(0)
#endif


#define NETREQUEST 0
#if NETREQUEST
#define HOTELREQUEST(...) NSLog(__VA_ARGS__)
#define FLIGHTREQUEST(...) NSLog(__VA_ARGS__)
#define COMMONREQUEST(...) NSLog(__VA_ARGS__)
#else
#define HOTELREQUEST(...) do{}while(0)
#define FLIGHTREQUEST(...) do{}while(0)
#define COMMONREQUEST(...) do{}while(0)
#endif

#define NETRESPONSE 0 
#if NETRESPONSE
#define COMMONRESPONSE(...) NSLog(__VA_ARGS__)
#else
#define COMMONRESPONSE(...) do{}while(0)
#endif


#define CARD_EDIT_DELETE 1