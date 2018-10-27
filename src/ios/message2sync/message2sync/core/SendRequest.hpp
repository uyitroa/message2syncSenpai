//
// Created by yuitora . on 06/10/2018.
//

#ifndef SRC_SENPAI_SENDREQUEST_H
#define SRC_SENPAI_SENDREQUEST_H

#include <iostream>

class SendRequest {
public:
	SendRequest();
	std::string sendpost(std::string data, std::string file, std::string url = "yuitora.localtunnel.me");
};


#endif //MESSAGE2SYNC_SENDREQUEST_H
