//
// Created by yuitora . on 06/10/2018.
//

#ifndef SRC_SENPAI_SENDREQUEST_H
#define SRC_SENPAI_SENDREQUEST_H

#include <iostream>

class SendRequest {
public:
	SendRequest();
	void sendpost(std::string data, std::string url = "yuitorayuitora.localtunnel.me");
};


#endif //MESSAGE2SYNC_SENDREQUEST_H
