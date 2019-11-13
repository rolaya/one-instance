import sys
import getopt
import getpass
import mysql.connector
from mysql.connector import Error

# package requirements:
#   1. Install pip with: "sudo apt install python-pip"
#   2. Install the python mysql connector with: "pip install mysql-connector-python-rf".

# Database creation requirements via this script ("testuser" may or may not be a user in the linux system):
#   1. In bash shell, login to MariaDB: "sudo mysql -u root -p"
#   2. Create a database user with: "create user 'testuser'@'localhost' identified by 'password';"
#   3. Grant all privileges to user: "grant all on *.* to 'testuser'@'localhost' identified by 'password' with grant option;"
# Note: Replace "password" with the actual user's password.

###############################################################################
# Establish mysql connection
###############################################################################
def mysql_connect(uname, upass, dname):

    # Default the mysql connection and cursor (handles)
    connection = None
    connection_params = None

    try:

        # "Bind" connection invocation parameters (for connecting to mysql)
        connection_params_mysql = {
            'host': 'localhost',
            'user': uname,
            'password': upass,
        }

        # "Bind" connection invocation parameters (for connecting to specific database)
        connection_params_database = {
            'host': 'localhost',
            'database': dname,
            'user': uname,
            'password': upass,
        }

        # It is possible to symply connect to mysql or connect to a specific mysql database
        if(dname == None):
            connection_params = connection_params_mysql
            print ("Connecting to mysql...")

        else:
            connection_params = connection_params_database
            print ("Connecting to mysql database: [" +dname +"]")

        # Connect to local mysql server (and possibly a specific database).
        connection = mysql.connector.connect(**connection_params)

    except Error as e:
        print("Failed MySQL connection!")
        print("Error: ", e)

    finally:
        return connection

###############################################################################
# Create database
###############################################################################
def database_create(connection, dname):

    # Default the mysql connection cursor (handles)
    cursor = None

    # Assume success creating database
    database_created = True

    try:
        # Format the database create command
        sql_command = "CREATE DATABASE " +"`" +dname +"`" +" CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

        # Get connection cursor and execute SQL
        cursor = connection.cursor()
        cursor.execute(sql_command)

        # Log the command used to create the database
        print ("Database: [" +dname +"] created via:")
        print ("[" +sql_command +"]")
    
    except Error as e:
    
        # Error encountered during database creation
        database_created = False
        print("Failed database creation with: [" +sql_command +"]")
        print("Error: ", e)

    finally:

        if (cursor != None):
            cursor.close()

        return database_created

###############################################################################
# Grant database privileges to user
###############################################################################
def database_grant_permissions(connection, uname, upass, dname):

    # Default the mysql connection cursor (handles)
    cursor = None

    # Later on we will come up with a more elegant way to "describe/provide" password in an opaque way...
    upass_opaque = "********"

    try:
        # Get connection cursor
        cursor = connection.cursor()

        # Grant misc. database privileges to user.
        sql_command = "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES ON " +"`" +dname +"`" +".* TO '" +uname +"'@'localhost' IDENTIFIED BY '" +upass +"';"
        sql_command_opaque = "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES ON " +"`" +dname +"`" +".* TO '" +uname +"'@'localhost' IDENTIFIED BY '" +upass_opaque +"';"
        cursor.execute(sql_command)
        print ("Database [" +dname +"] privileges granted to user [" +uname +"] via:")
        print ("[" +sql_command_opaque +"]")

    except Error as e:
        
        # Error encountered granting misc. permissions to user on database
        print("Failed granting privileges to user via: [" +sql_command +"]")
        print("Error: ", e)

    finally:

        if (cursor != None):
            cursor.close()

def main(argv):

    user_name = None
    database_name  = None
    password_prompt = ''
    connection = None

    try:

        # Define the expected command parameters
        opts, args = getopt.getopt(argv, "hu:d:", ["user=","database="])

    except getopt.GetoptError:

        print 'init-database-for-contenta-deployment.py -u <username> -d <database>'
        sys.exit(2)

    # Process user entered options, we need the user name and the name of the database (to create)
    for opt, arg in opts:

        if opt == '-h':
            print 'init-database-for-contenta-deployment.py -u <username> -d <database>'
            sys.exit()
        elif opt in ("-u", "--user"):
            user_name = arg
        elif opt in ("-d", "--database"):
            database_name = arg
    
    if user_name == None or database_name == None:
        print 'usage: test-create-database.py -u <username> -d <database>'
        sys.exit() 

    print ("User:     [" +user_name +"]")
    print ("Database: [" +database_name +"]")

    # Request mysql user password
    password_prompt = "Enter mysql user [" +user_name +"] password: "
    user_pass = getpass.getpass(prompt=password_prompt)

    # Connect to mysql (no particular database)
    connection = mysql_connect(uname = user_name, upass = user_pass, dname =  None)

    # MySQL connection established?
    if (connection != None and connection.is_connected()):

        # For informational purposes
        db_Info = connection.get_server_info()
        print("Connected to MySQL server version: [" +db_Info +"]")
        
        # Create the requested database
        database_created = database_create(connection, dname =  database_name)
        print("Closing MySQL connection...")
        connection.close()
        connection = None
        
        if(database_created):
            
            # Connect to the newly created database
            connection = mysql_connect(uname = user_name, upass = user_pass, dname = database_name)

            # MySQL database connection established?
            if (connection != None and connection.is_connected()):

                # Grant misc. database permissions to user
                database_grant_permissions(connection, uname = user_name, upass = user_pass, dname = database_name)
                print("Closing MySQL connection...")
                connection.close()
                connection = None            


if __name__ == "__main__":
   main(sys.argv[1:])
