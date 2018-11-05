//
//  wrapper.h
//  message2sync
//
//  Created by yuitora . on 20/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//
#ifdef __cplusplus
extern "C" {
#endif
	const char* sendGetRequest(const char *message, const char *file, const char *server);
	const void* initializeDeta(const char *filename);
	const char* readLine(const void *object, int ide, const char *server);
	void writeLine(const void *object, const char *line, const char *server);
	int getNumberLines(const void *object, const char *server);
	
	void updateLastServer(const void *object, const char *servername);
	const char* getLastServer(const void *object);
	const char* getServers(const void *object);
	
	void createServerTable(const void *object, const char *servername);
	void deleteDeta(const void *object);
	void freeChar(const char *character);
#ifdef __cplusplus
}
#endif
