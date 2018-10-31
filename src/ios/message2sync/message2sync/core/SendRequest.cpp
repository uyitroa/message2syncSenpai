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

void getImportant(std::string &mystring) {
	for(int x = mystring.size() - 1; x >= 0; x--) {
		if (mystring[x] == '\n' && mystring[x - 1] == '\r') {
			mystring = mystring.substr(x + 1, mystring.size());
			break;
		}
	}
}


std::string SendRequest::sendpost(std::string data, std::string file, std::string url) {
	using namespace std;

	ofstream myfile;
	myfile.open(file, fstream::app);
	myfile << data << "\\\\\\\\" << "\n";
	
	int sock;
	struct sockaddr_in client;
	int PORT = 80;
	struct hostent *host = gethostbyname(url.c_str());
	
	if ( (host == NULL) || (host->h_addr == NULL) ) {
		return "Error retrieving DNS information." ;
	}
	
	bzero(&client, sizeof(client));
	client.sin_family = AF_INET;
	client.sin_port = htons( PORT );
	memcpy(&client.sin_addr, host->h_addr, host->h_length);
	
	sock = socket(AF_INET, SOCK_STREAM, 0);
	
	if (sock < 0) {
		return "Error creating socket.";
	}
	
	if ( connect(sock, (struct sockaddr *)&client, sizeof(client)) < 0 ) {
		close(sock);
		return "Could not connect";
	}
	
	std::string stringbuilder = "";
	
	for (int index = 0; index < data.size(); index++) {
		if (data[index] == '/') {
			stringbuilder += "*_*_";
		} else {
			stringbuilder += data[index];
		}
	}
	
	stringstream ss;
	ss << "GET /command/" << stringbuilder.c_str() << "/" << " HTTP/1.1\r\n"
	<< "Host: " << url.c_str() << "\r\n"
	<< "Accept: application/json\r\n"
	<< "Connection: close\r\n"
	<< "\r\n\r\n";
	string request = ss.str();
	
	if (send(sock, request.c_str(), request.length(), 0) != (int)request.length()) {
		return "Error sending request.";
	}

	char cur;
	string mychar = "";
	myfile << "Computer: ";
	while ( read(sock, &cur, 1) > 0 ) {
		mychar += cur;
	}
	getImportant(mychar);
	myfile << mychar;
	myfile << "\\\\\\\\";
	myfile << "\n";
	myfile.close();
	return mychar;
}
