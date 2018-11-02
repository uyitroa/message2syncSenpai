//
//  Deta.cpp
//  message2sync
//
//  Created by yuitora . on 01/11/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//

#include "Deta.hpp"

Deta::Deta(const char *filename) {
	int rc = sqlite3_open(filename, &db);
	if (rc)
		sqlite3_errmsg(db);
	this->filename = filename;
	if (!tableExist("info")) {
		createTable("info", "serversname VARCHAR(100), lastserver VARCHAR(100), databasename VARCHAR(100)");
		insert("info", "serversname, lastserver, databasename", "'', '', 'message2sync'");
	}
}

Deta::~Deta() {
	sqlite3_close(db);
}

void Deta::exec(const char* command) {
	if(sqlite3_exec(db, command, nullptr, nullptr, nullptr)) {
		std::cout << command << "\n";
		std::cout << sqlite3_errmsg(db) << "\n";
		throw std::string("sql error");
	}
}

int Deta::getNumberLines(std::string server) {
	if (server == "")
		return -1;
	std::string command = "select max(id) from " + server;
	sqlite3_stmt *stmt;
	sqlite3_prepare(db, command.c_str(), -1, &stmt, nullptr);
	sqlite3_step(stmt);
	
	int result = sqlite3_column_int(stmt, 0);
	sqlite3_finalize(stmt);
	return result;
}

std::string Deta::readLine(int id, std::string server) {
	sqlite3_stmt *data = read(server, "id = " + std::to_string(id));
	sqlite3_step(data);
	std::string line = std::string((char*) sqlite3_column_text(data, 1));
	sqlite3_finalize(data);
	return line;
}

void Deta::writeLine(std::string line, std::string server) {
	int id = getNumberLines(server) + 1;
	insert(server, "id, text", std::to_string(id) + ", '" + line + "'");
}

void Deta::updateLastServer(std::string servername) {
	update("info", "databasename = 'message2sync'", "lastserver = '" + servername + "'");
}

std::string Deta::getLastServer() {
	sqlite3_stmt *stmt = readAll("info");
	sqlite3_step(stmt);
	
	std::string last = std::string((char*) sqlite3_column_text(stmt, 1));
	sqlite3_finalize(stmt);

	return last;
}

std::string Deta::getServers() {
	sqlite3_stmt *stmt = readAll("info");
	sqlite3_step(stmt);
	std::string servers = std::string((char*) sqlite3_column_text(stmt, 0));
	sqlite3_finalize(stmt);
	return servers;
}

void Deta::createServerTable(std::string servername) {
	createTable(servername, "id, text");
	insert(servername, "id, text", "-1, ''");
	update("info", "databasename = 'message2sync'",
		   "serversname = '" + getServers() + "|" + servername +"'");
}



void Deta::createTable(std::string column, std::string row) {
	/*
	 * the last element is always the id
	 */
	std::string command = "CREATE TABLE " + column + "(" + row + ")";
	this->exec(command.c_str());
}

void Deta::deleteTable(std::string column) {
	std::string command = "DROP TABLE " + column;
	this->exec(command.c_str());
}

bool Deta::tableExist(std::string column) {
	sqlite3_stmt *stmt;
	std::string command = "SELECT name FROM sqlite_master WHERE type='table' AND name='" + column + "'";
	
	sqlite3_prepare( db, command.c_str(), -1, &stmt, NULL );
	sqlite3_step(stmt);
	
	bool exist = !(sqlite3_column_text(stmt, 0) == NULL);
	
	sqlite3_finalize(stmt);
	return exist;
	
}

/*
 * CRUD TO TABLE
 */
void Deta::insert(std::string column, std::string field_name, std::string values) {
	std::string command = "INSERT INTO " + column + " (" + field_name + ") VALUES (" + values + ")";
	this->exec(command.c_str());
}

void Deta::update(std::string column, std::string old_row,
				  std::string new_row) {
	std::string command = "UPDATE " + column + " SET " + new_row + " WHERE " + old_row;
	this->exec(command.c_str());
}

sqlite3_stmt* Deta::read(std::string column, std::string values) {
	std::string command = std::string("SELECT * FROM ") + column;
	command += std::string(" WHERE ") + values;
	
	sqlite3_stmt *stmt;
	sqlite3_prepare(db, command.c_str(), -1, &stmt, nullptr);
	
	return stmt;
}

sqlite3_stmt* Deta::readAll(std::string column) {
	std::string command = std::string("SELECT * FROM ") + column;
	
	sqlite3_stmt *stmt;
	sqlite3_prepare(db, command.c_str(), -1, &stmt, nullptr);
	
	return stmt;
	
}
