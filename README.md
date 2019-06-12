# sqldump-to
[![Build Status](https://travis-ci.org/arjunmehta/sqldump-to.svg?branch=master)](https://travis-ci.org/arjunmehta/sqldump-to)

This stdin stream compatible command line tool takes a SQL dump stream and converts it to newline delimited JSON. **Currently this tool can only process dump files for individual tables.** In the future this module may support other output formats and have additional features ([with your help](https://github.com/arjunmehta/sqldump-to/issues)).

- Convert SQL table dump to comma-separated JSON for import to BigQuery or other tools.
- Output JSON schema to file. **[Request export format](https://github.com/arjunmehta/sqldump-to/issues)**
- Stream-based processor makes efficient use of resources (low memory/disk requirements).
- Use multiple worker processes to increase performance/consumption.
- stdin/stdout compatible.
- Supports MySQL and MariaDB SQL dumpfiles and schema. **[Request dump format](https://github.com/arjunmehta/sqldump-to/issues)**


## Get Started
### Installation
```bash
npm install -g sqldump-to
```

### Usage
To use, simply pipe a MySQL compatible database dump to the tool. The schema will be read and the output will be newline delimited JSON, with object keys matching the column names of your tables.


#### Examples
```bash
# Output from dump file newline delimited JSON to stdout
cat tablename.sql | sqldump-to
```
```bash
# Output directly from database to JSON file
mysqldump -u user -psecret dbname tablename | sqldump-to > tablename.json
```
```bash
# Track progress from gzipped dump to newline delimited JSON to a file
pv tablename.sql.gz | gunzip -c | sqldump-to > tablename.json
```
```bash
# Output to a specific directory from a download stream
curl http://dumps.mydumps.com/tablename.sql.gz | gunzip -c | sqldump-to -d ./output
```
```bash
# Output to gzipped json file with a separate schema file from a download stream
curl http://dumps.mydumps.com/tablename.sql.gz | gunzip -c | sqldump-to -s | gzip -9 > tablename.json.gz
```

## Flags
### --dir-output=\<path>, -d
Output to file in a specific directory. Filename will be `{tablename}.json`. Selecting this option will disable writing to stdout in favour of write to disk.

```bash
# Output newline delimited JSON to ./output/tablename.json
cat tablename.sql | sqldump-to -d ./output
```

### --write-workers=\<number of workers>, -w
Adds extra write workers and splits the output into separate files. Only works when writing to disk (ie. when `--dir-output` given).

On most systems, the optimal number of workers is `2`, but you can experiment with different values. Filenames will be `{tablename}_0.json`, `{tablename}_1.json`, etc.

```bash
# Use 2 workers to output ./output/tablename_0.json and ./output/tablename_1.json
cat tablename.sql | sqldump-to -d ./output -w 2
```

### --schema, -s
Output the detected schema as JSON to a file. Filename will be `{tablename}_schema.json`.

If `output-dir` is not set, the schema file will be written to current directory. Otherwise will be writted to the directory specified in `output-dir`.

```bash
# Output to stdout
# Write embedded schema to ./tablename_schema.json
cat tablename.sql | sqldump-to -s
```
```bash
# Output to ./output/tablename.json
# Write Standard SQL schema to ./output/tablename_schema.json
cat tablename.sql | sqldump-to -d ./output -s standard
```

## License
```
The MIT License (MIT)
Copyright (c) 2019 Arjun Mehta
```
