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

void sendGetRequest(const char *message) {
	SendRequest sendRequest;

	std::string msg = message;
	msg = "1|" + msg;

	sendRequest.sendpost(msg);
}
