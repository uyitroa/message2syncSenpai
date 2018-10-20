//
// Created by yuitora . on 06/10/2018.
//

#include "SendRequest.hpp"
#include <ctype.h>
#include <cstring>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <unistd.h>
#include <sstream>
#include <fstream>
#include <string>

SendRequest::SendRequest() = default;

void SendRequest::sendpost(std::string data, std::string url) {
	using namespace std;
	int sock;
	struct sockaddr_in client;
	int PORT = 80;
	struct hostent *host = gethostbyname(url.c_str());
	
	if ( (host == NULL) || (host->h_addr == NULL) ) {
		cout << "Error retrieving DNS information." << endl;
		exit(1);
	}
	
	bzero(&client, sizeof(client));
	client.sin_family = AF_INET;
	client.sin_port = htons( PORT );
	memcpy(&client.sin_addr, host->h_addr, host->h_length);
	
	sock = socket(AF_INET, SOCK_STREAM, 0);
	
	if (sock < 0) {
		cout << "Error creating socket." << endl;
		exit(1);
	}
	
	if ( connect(sock, (struct sockaddr *)&client, sizeof(client)) < 0 ) {
		close(sock);
		cout << "Could not connect" << endl;
		exit(1);
	}
	
	stringstream ss;
	ss << "GET /" << data.c_str() << "/" << " HTTP/1.1\r\n"
	<< "Host: " << url.c_str() << "\r\n"
	<< "Accept: application/json\r\n"
	<< "Connection: close\r\n"
	<< "\r\n\r\n";
	string request = ss.str();
	
	if (send(sock, request.c_str(), request.length(), 0) != (int)request.length()) {
		cout << "Error sending request." << endl;
		exit(1);
	}
	
	char cur;
	while ( read(sock, &cur, 1) > 0 ) {
		cout << cur;
	}

}
