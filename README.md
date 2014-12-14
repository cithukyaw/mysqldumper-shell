# MySQL Dumper Shell

The simple and quick MySQL database backup program through CLI or Bash. It dumps all databases into a directory specified. It exports `.sql` file for each database with the file name format of `<db_name>_<YYYYMMDD>.sql`

## Instruction

Extract the archive download in a folder. Let's say you have `D:\mysqldumper-shell\mysqldumper.bat`,

- In CLI, change the directory to where `mysqldumper.bat` exists
- Type and run `mysqldumper`.


    D:\mysqldumper-shell> mysqldumper

By default, it will create a directory `path\to\user\directory\.mysqlbackup` and exported the sql files into the directory.

## Author
[Sithu K.](http://sithukyaw.com)

## License
Released under the [MIT License](LICENSE).
