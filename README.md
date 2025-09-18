# MySQL Dumper Shell

The simple and quick MySQL database backup program through terminal or command line using a single compact command. It dumps all databases into a directory specified. The script is available for both Linux and Windows.

It exports `.sql` file for each database with the file name format of `<db_name>_<YYYYMMDD>.sql` by default. When the argument `--archive` or `-a` is provided, sql file will be archived into `<db_name>_<YYYYMMDD>.zip`.

## Usage

    mysqldumper [options]

    Options:
     --archive (-a)  Create zip file for the dump file
     --dbs (-d)      Databases to be dumped, e.g., -d mydb1 mydb2

If you omit the options, your MySQL user should have `SHOW DATABASES` privilege.

# Instruction (Linux)

Place the downloaded script file `mysqldumper` in a directory you like; let's say have `/var/local/mysqldumper-shell/mysqldumper`.

    $ cd /var/local/mysqldumper-shell

    # export sql files for all dbs
    $ ./mysqldumper

    # export sql files for the specific dbs only - mydb1 and mydb2
    $ ./mysqldumper -d mydb1 mydb2

    # export zip files for all dbs
    $ ./mysqldumper -a

    # export zip files for the specific dbs only - mydb1 and mydb2
    $ ./mysqldumper -d mydb1 mydb2 -a

You can alternatively [put it in your PATH](http://linuxcommand.org/wss0010.php#path) so that you could run it globally without changing directory.

    $ mysqldumper

### Note for Linux

* Upon first usage, you will get a MySQL configuration notice and simply follow the instruction showing in the terminal.
* All dumped sql files will be stored in a directory of home `$HOME/.mysqlbackup`.

# Instruction (Windows)

Place the downloaded script file `mysqldumper.bat` in a directory you like; let's say have `C:\bin\mysqldumper-shell\mysqldumper.bat`.

    C:\Users\%Username%> cd\
    C:\> cd bin\mysqldumper-shell

    # export sql files for all dbs
    C:\bin\mysqldumper-shell> ./mysqldumper.bat

    # export sql files for or the specific dbs only - mydb1 and mydb2
    C:\bin\mysqldumper-shell> ./mysqldumper.bat -d mydb1 mydb2

    # export zip files for all dbs
    C:\bin\mysqldumper-shell> ./mysqldumper.bat -a

    # export zip files for the specific dbs only - mydb1 and mydb2
    C:\bin\mysqldumper-shell> ./mysqldumper.bat -d mydb1 mydb2 -a

If you want to run it globally without changing directory, you can put it in your PATH using [GUI](http://www.computerhope.com/issues/ch000549.htm) or [command line](http://stackoverflow.com/a/9546345/1179841).

    C:\Users\%Username%> mysqldumper

### Note for Windows

* Upon first usage, you will get a MySQL configuration notice and simply follow the instruction showing in the command line.
* You may need to configure your path of `mysql.exe` location in the line 20 of the script.
* All dumped sql files will be stored in a directory of user profile, for example, `C:\Users\%Username%\.mysqlbackup`. You can change path at line 35.

# Author
[Sithu](http://github.com/cithukyaw)

# License
Released under the [MIT License](LICENSE).
