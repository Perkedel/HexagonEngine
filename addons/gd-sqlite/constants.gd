extends Reference

class_name GDSQLITE

"""
** CAPI3REF: Result Codes
** KEYWORDS: {result code definitions}
**
** Many SQLite functions return an integer result code from the set shown
** here in order to indicate success or failure.
**
** New error codes may be added in future versions of SQLite.
**
** See also: [extended result code definitions]
"""

const OK         := 0    # Successful result

""" beginning-of-error-codes """
const ERROR      := 1    # Generic error
const INTERNAL   := 2    # Internal logic error in SQLite
const PERM       := 3    # Access permission denied
const ABORT      := 4    # Callback routine requested an abort
const BUSY       := 5    # The database file is locked
const LOCKED     := 6    # A table in the database is locked
const NOMEM      := 7    # A malloc() failed
const READONLY   := 8    # Attempt to write a readonly database
const INTERRUPT  := 9    # Operation terminated by sqlite3_interrupt()
const IOERR      := 10   # Some kind of disk I/O error occurred 
const CORRUPT    := 11   # The database disk image is malformed
const NOTFOUND   := 12   # Unknown opcode in sqlite3_file_control()
const FULL       := 13   # Insertion failed because database is full
const CANTOPEN   := 14   # Unable to open the database file
const PROTOCOL   := 15   # Database lock protocol error
const EMPTY      := 16   # Internal use only
const SCHEMA     := 17   # The database schema changed
const TOOBIG     := 18   # String or BLOB exceeds size limit
const CONSTRAINT := 19   # Abort due to constraint violation
const MISMATCH   := 20   # Data type mismatch
const MISUSE     := 21   # Library used incorrectly
const NOLFS      := 22   # Uses OS features not supported on host
const AUTH       := 23   # Authorization denied
const FORMAT     := 24   # Not used
const RANGE      := 25   # 2nd parameter to sqlite3_bind out of range
const NOTADB     := 26   # File opened that is not a database file
const NOTICE     := 27   # Notifications from sqlite3_log()
const WARNING    := 28   # Warnings from sqlite3_log()
const ROW        := 100  # sqlite3_step() has another row ready
const DONE       := 101  # sqlite3_step() has finished executing
""" end-of-error-codes """

"""
** CAPI3REF: Extended Result Codes
** KEYWORDS: {extended result code definitions}
**
** In its default configuration, SQLite API routines return one of 30 integer
** [result codes].  However, experience has shown that many of
** these result codes are too coarse-grained.  They do not provide as
** much information about problems as programmers might like.  In an effort to
** address this, newer versions of SQLite (version 3.3.8 [dateof:3.3.8]
** and later) include
** support for additional result codes that provide more detailed information
** about errors. These [extended result codes] are enabled or disabled
** on a per database connection basis using the
** [sqlite3_extended_result_codes()] API.  Or, the extended code for
** the most recent error can be obtained using
** [sqlite3_extended_errcode()].
"""

const ERROR_MISSING_COLLSEQ   := (ERROR      | (1<<8))
const ERROR_RETRY             := (ERROR      | (2<<8))
const ERROR_SNAPSHOT          := (ERROR      | (3<<8))
const IOERR_READ              := (IOERR      | (1<<8))
const IOERR_SHORT_READ        := (IOERR      | (2<<8))
const IOERR_WRITE             := (IOERR      | (3<<8))
const IOERR_FSYNC             := (IOERR      | (4<<8))
const IOERR_DIR_FSYNC         := (IOERR      | (5<<8))
const IOERR_TRUNCATE          := (IOERR      | (6<<8))
const IOERR_FSTAT             := (IOERR      | (7<<8))
const IOERR_UNLOCK            := (IOERR      | (8<<8))
const IOERR_RDLOCK            := (IOERR      | (9<<8))
const IOERR_DELETE            := (IOERR      | (10<<8))
const IOERR_BLOCKED           := (IOERR      | (11<<8))
const IOERR_NOMEM             := (IOERR      | (12<<8))
const IOERR_ACCESS            := (IOERR      | (13<<8))
const IOERR_CHECKRESERVEDLOCK := (IOERR      | (14<<8))
const IOERR_LOCK              := (IOERR      | (15<<8))
const IOERR_CLOSE             := (IOERR      | (16<<8))
const IOERR_DIR_CLOSE         := (IOERR      | (17<<8))
const IOERR_SHMOPEN           := (IOERR      | (18<<8))
const IOERR_SHMSIZE           := (IOERR      | (19<<8))
const IOERR_SHMLOCK           := (IOERR      | (20<<8))
const IOERR_SHMMAP            := (IOERR      | (21<<8))
const IOERR_SEEK              := (IOERR      | (22<<8))
const IOERR_DELETE_NOENT      := (IOERR      | (23<<8))
const IOERR_MMAP              := (IOERR      | (24<<8))
const IOERR_GETTEMPPATH       := (IOERR      | (25<<8))
const IOERR_CONVPATH          := (IOERR      | (26<<8))
const IOERR_VNODE             := (IOERR      | (27<<8))
const IOERR_AUTH              := (IOERR      | (28<<8))
const IOERR_BEGIN_ATOMIC      := (IOERR      | (29<<8))
const IOERR_COMMIT_ATOMIC     := (IOERR      | (30<<8))
const IOERR_ROLLBACK_ATOMIC   := (IOERR      | (31<<8))
const LOCKED_SHAREDCACHE      := (LOCKED     | (1<<8))
const LOCKED_VTAB             := (LOCKED     | (2<<8))
const BUSY_RECOVERY           := (BUSY       | (1<<8))
const BUSY_SNAPSHOT           := (BUSY       | (2<<8))
const CANTOPEN_NOTEMPDIR      := (CANTOPEN   | (1<<8))
const CANTOPEN_ISDIR          := (CANTOPEN   | (2<<8))
const CANTOPEN_FULLPATH       := (CANTOPEN   | (3<<8))
const CANTOPEN_CONVPATH       := (CANTOPEN   | (4<<8))
const CANTOPEN_DIRTYWAL       := (CANTOPEN   | (5<<8))  # Not Used
const CORRUPT_VTAB            := (CORRUPT    | (1<<8))
const CORRUPT_SEQUENCE        := (CORRUPT    | (2<<8))
const READONLY_RECOVERY       := (READONLY   | (1<<8))
const READONLY_CANTLOCK       := (READONLY   | (2<<8))
const READONLY_ROLLBACK       := (READONLY   | (3<<8))
const READONLY_DBMOVED        := (READONLY   | (4<<8))
const READONLY_CANTINIT       := (READONLY   | (5<<8))
const READONLY_DIRECTORY      := (READONLY   | (6<<8))
const ABORT_ROLLBACK          := (ABORT      | (2<<8))
const CONSTRAINT_CHECK        := (CONSTRAINT | (1<<8))
const CONSTRAINT_COMMITHOOK   := (CONSTRAINT | (2<<8))
const CONSTRAINT_FOREIGNKEY   := (CONSTRAINT | (3<<8))
const CONSTRAINT_FUNCTION     := (CONSTRAINT | (4<<8))
const CONSTRAINT_NOTNULL      := (CONSTRAINT | (5<<8))
const CONSTRAINT_PRIMARYKEY   := (CONSTRAINT | (6<<8))
const CONSTRAINT_TRIGGER      := (CONSTRAINT | (7<<8))
const CONSTRAINT_UNIQUE       := (CONSTRAINT | (8<<8))
const CONSTRAINT_VTAB         := (CONSTRAINT | (9<<8))
const CONSTRAINT_ROWID        := (CONSTRAINT | (10<<8))
const NOTICE_RECOVER_WAL      := (NOTICE     | (1<<8))
const NOTICE_RECOVER_ROLLBACK := (NOTICE     | (2<<8))
const WARNING_AUTOINDEX       := (WARNING    | (1<<8))
const AUTH_USER               := (AUTH       | (1<<8))
const OK_LOAD_PERMANENTLY     := (OK         | (1<<8))

"""
** CAPI3REF: Fundamental Datatypes
** KEYWORDS: SQLITE_TEXT
**
** ^(Every value in SQLite has one of five fundamental datatypes:
**
** <ul>
** <li> 64-bit signed integer
** <li> 64-bit IEEE floating point number
** <li> string
** <li> BLOB
** <li> NULL
** </ul>)^
**
** These constants are codes for each of those types.
**
** Note that the SQLITE_TEXT constant was also used in SQLite version 2
** for a completely different meaning.  Software that links against both
** SQLite version 2 and SQLite version 3 should use SQLITE3_TEXT, not
** SQLITE_TEXT.
"""

const INTEGER := 1
const FLOAT   := 2
const BLOB    := 4
const NULL    := 5
const TEXT    := 3

"""
** CAPI3REF: Status Parameters for prepared statements
** KEYWORDS: {SQLITE_STMTSTATUS counter} {SQLITE_STMTSTATUS counters}
**
** These preprocessor macros define integer codes that name counter
** values associated with the [sqlite3_stmt_status()] interface.
** The meanings of the various counters are as follows:
**
** <dl>
** [[SQLITE_STMTSTATUS_FULLSCAN_STEP]] <dt>SQLITE_STMTSTATUS_FULLSCAN_STEP</dt>
** <dd>^This is the number of times that SQLite has stepped forward in
** a table as part of a full table scan.  Large numbers for this counter
** may indicate opportunities for performance improvement through 
** careful use of indices.</dd>
**
** [[SQLITE_STMTSTATUS_SORT]] <dt>SQLITE_STMTSTATUS_SORT</dt>
** <dd>^This is the number of sort operations that have occurred.
** A non-zero value in this counter may indicate an opportunity to
** improvement performance through careful use of indices.</dd>
**
** [[SQLITE_STMTSTATUS_AUTOINDEX]] <dt>SQLITE_STMTSTATUS_AUTOINDEX</dt>
** <dd>^This is the number of rows inserted into transient indices that
** were created automatically in order to help joins run faster.
** A non-zero value in this counter may indicate an opportunity to
** improvement performance by adding permanent indices that do not
** need to be reinitialized each time the statement is run.</dd>
**
** [[SQLITE_STMTSTATUS_VM_STEP]] <dt>SQLITE_STMTSTATUS_VM_STEP</dt>
** <dd>^This is the number of virtual machine operations executed
** by the prepared statement if that number is less than or equal
** to 2147483647.  The number of virtual machine operations can be 
** used as a proxy for the total work done by the prepared statement.
** If the number of virtual machine operations exceeds 2147483647
** then the value returned by this statement status code is undefined.
**
** [[SQLITE_STMTSTATUS_REPREPARE]] <dt>SQLITE_STMTSTATUS_REPREPARE</dt>
** <dd>^This is the number of times that the prepare statement has been
** automatically regenerated due to schema changes or change to 
** [bound parameters] that might affect the query plan.
**
** [[SQLITE_STMTSTATUS_RUN]] <dt>SQLITE_STMTSTATUS_RUN</dt>
** <dd>^This is the number of times that the prepared statement has
** been run.  A single "run" for the purposes of this counter is one
** or more calls to [sqlite3_step()] followed by a call to [sqlite3_reset()].
** The counter is incremented on the first [sqlite3_step()] call of each
** cycle.
**
** [[SQLITE_STMTSTATUS_MEMUSED]] <dt>SQLITE_STMTSTATUS_MEMUSED</dt>
** <dd>^This is the approximate number of bytes of heap memory
** used to store the prepared statement.  ^This value is not actually
** a counter, and so the resetFlg parameter to sqlite3_stmt_status()
** is ignored when the opcode is SQLITE_STMTSTATUS_MEMUSED.
** </dd>
** </dl>
"""

const STMTSTATUS_FULLSCAN_STEP := 1
const STMTSTATUS_SORT          := 2
const STMTSTATUS_AUTOINDEX     := 3
const STMTSTATUS_VM_STEP       := 4
const STMTSTATUS_REPREPARE     := 5
const STMTSTATUS_RUN           := 6
const STMTSTATUS_MEMUSED       := 99
