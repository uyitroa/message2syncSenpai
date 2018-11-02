//
//  Deta.hpp
//  message2sync
//
//  Created by yuitora . on 01/11/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//

#ifndef Deta_hpp
#define Deta_hpp

#include <stdio.h>
#include <iostream>
#include <sqlite3.h>

class Deta {
private:
	sqlite3 *db;
	std::string filename;

	void exec(const char *cmd);
	bool tableExist(std::string table);
	// Create and delete table
	void createTable(std::string column, std::string row);
	void deleteTable(std::string column);
	
	/*
	 * Allow user to manage data that they want to store
	 */
	void insert(std::string column, std::string field_name, std::string values);
	sqlite3_stmt* read(std::string column, std::string values);
	sqlite3_stmt* readAll(std::string column);
	void update(std::string column, std::string old_row, std::string new_row);
	
public:
	Deta(const char *filename);
	~Deta();
	
	std::string readLine(int id, std::string server);
	void writeLine(std::string line, std::string server);
	int getNumberLines(std::string server);
	
	void updateLastServer(std::string servername);
	std::string getLastServer();
	std::string getServers();
	
	void createServerTable(std::string servername);

	
};
#endif /* Deta_hpp */
