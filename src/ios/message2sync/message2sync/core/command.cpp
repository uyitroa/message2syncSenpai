//
//  command.cpp
//  message2sync
//
//  Created by yuitora . on 20/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//
//
#include "../bridger/wrapper.h"

#include <stdio.h>
#include "SendRequest.hpp"
#include "Deta.hpp"
#include <sys/types.h>
#include <dirent.h>

Deta* objectConverter(const void *object) {
	return (Deta *)object;
}

const char* allocateCString(std::string result) {
	char *output = new char[result.size() + 1];
	strcpy(output, result.c_str());
	return output;
}

const char* sendGetRequest(const char *message, const char *file) {
	SendRequest sendRequest;

	std::string msg = message;
	msg = "You: " + msg;
	
	msg = sendRequest.sendpost(msg, file);
	return strdup(msg.c_str());
}

const void* initializeDeta(const char *filename) {
	Deta *deta = new Deta(filename);
	return (void *)deta;
}

void deleteDeta(const void* object) {
	Deta *deta = objectConverter(object);
	delete deta;
}


int getNumberLines(const void *object, const char *server) {
	Deta *deta = objectConverter(object);
	return deta->getNumberLines(server);
}

const char* readLine(const void *object, int id, const char *server) {
	Deta *deta = objectConverter(object);
	return allocateCString(deta->readLine(id, server));
}

void writeLine(const void *object, const char *line, const char *server) {
	Deta *deta = objectConverter(object);
	deta->writeLine(line, server);
}

void updateLastServer(const void *object, const char *servername) {
	Deta *deta = objectConverter(object);
	deta->updateLastServer(servername);
}

const char* getLastServer(const void *object) {
	Deta *deta = objectConverter(object);
	return allocateCString(deta->getLastServer());
}

const char* getServers(const void *object) {
	Deta *deta = objectConverter(object);
	return allocateCString(deta->getServers());
}

void createServerTable(const void *object, const char *servername) {
	Deta *deta = objectConverter(object);
	deta->createServerTable(servername);
}

void freeChar(const char *character) {
	delete character;
}
