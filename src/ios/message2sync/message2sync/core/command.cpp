//
//  command.cpp
//  message2sync
//
//  Created by yuitora . on 20/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//
//
#include <stdio.h>
#include "SendRequest.hpp"
#include "../bridger/wrapper.h"

const char* sendGetRequest(const char *message, const char *file) {
	SendRequest sendRequest;

	std::string msg = message;
	msg = "You: " + msg;
	msg = sendRequest.sendpost(msg, file);
	return strdup(msg.c_str());
}
