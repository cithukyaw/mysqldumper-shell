# MySQL Dumper Shell

The simple and quick MySQL database backup program through terminal or command line using a single compact command. It dumps all databases into a directory specified. It exports `.sql` file for each database with the file name format of `<db_name>_<YYYYMMDD>.sql`. The script is available for both Linux and Windows.

## Usage

    mysqldumper [options]

    Options:
     --dbs (-d)      Databases to be dumped, e.g., -d mydb1 mydb2

If you omit the options, your MySQL user should have `SHOW DATABASES` privilege.

# Instruction (Linux)

Place the downloaded script file `mysqldumper` in a directory you like; let's say have `/var/local/mysqldumper-shell/mysqldumper`.

    $ cd /var/local/mysqldumper-shell
    $ ./mysqldumper

You can alternatively [put it in your PATH](http://linuxcommand.org/wss0010.php#path) so that you could run it globally without changing directory.

    $ mysqldumper

### Note for Linux

* Upon first usage, you will get a MySQL configuration notice and simply follow the instruction showing in the terminal.
* All dumped sql files will be stored in a directory of home `$HOME/.mysqlbackup`.

# Instruction (Windows)

Place the downloaded script file `mysqldumper.bat` in a directory you like; let's say have `C:\bin\mysqldumper-shell\mysqldumper.bat`.

    C:\Users\%Username%> cd\
    C:\> cd bin\mysqldumper-shell
    C:\bin\mysqldumper-shell> mysqldumper.bat

If you want to run it globally without changing directory, you can put it in your PATH using [GUI](http://www.computerhope.com/issues/ch000549.htm) or [command line](http://stackoverflow.com/a/9546345/1179841).

    C:\Users\%Username%> mysqldumper

### Note for Windows

* Upon first usage, you will get a MySQL configuration notice and simply follow the instruction showing in the command line.
* You may need to configure your path of `mysql.exe` location in the line 20 of the script.
* All dumped sql files will be stored in a directory of user profile, for example, `C:\Users\%Username%\.mysqlbackup`. You can change path at line 35.

# Author
[Sithu K.](http://www.phplucidframe.com/sithu)

# License
Released under the [MIT License](LICENSE).
