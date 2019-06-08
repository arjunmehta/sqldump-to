# sqldump-to
[![Build Status](https://travis-ci.org/arjunmehta/node-sqldump-to-json.svg?branch=master)](https://travis-ci.org/arjunmehta/node-sqldump-to-json)

This stdin stream compatible command line tool takes a SQL dump stream and converts it to newline delimited JSON. In the future this module may support other formats and have additional features ([with your help](https://github.com/arjunmehta/node-sqldump-to-json/issues)).

## Get Started
### Installation
```bash
npm install -g sqldump-to
```

### Usage
To use, simply pipe a SQL dump read stream to the tool. The schema will be read and the output will be newline delimited JSON, with object keys matching the column names of your tables.

#### Examples
```bash
# Output from dumpfile newline delimited JSON to stdout
cat tablename.sql | sqldump-to
```
```bash
# Track progress from gzipped dump to newline delimited JSON to a file
pv tablename.sql.gz | gunzip -c | sqldump-to > mydumpfile.json
```
```bash
# Output from download
curl http://dumps.mydumps.com/tablename.sql.gz | gunzip -c | sqldump-to > tablename.json
```

## Flags
#### --output-dir=\<path>, -d
Output to a specific directory. Filename will be `{tablename}.json`

```bash
# Output newline delimited JSON to ./output/tablename.json
cat tablename.sql | sqldump-to -d ./output
```

#### --write-workers=\<number of workers>, -w
Adds extra write workers and splits the output into separate files.

On most systems, the optimal number of workers is `2`, but you can experiment with different values. Filenames will be `{tablename}_0.json`, `{tablename}_1.json`, etc.

```bash
# Use 2 workers to output ./output/tablename_0.json and ./output/tablename_1.json
cat tablename.sql | sqldump-to -d ./output -w 2
```

#### --schema=\[schema format], -s
Output the detected schema as JSON to a file. Filename will be `$tablename_schema.json`.

**`schema format`** may be one of:
- **default** (MySQL)
- **standard**  (Standard SQL)

If `output-dir` is not set, the schema file will be written to current directory. Otherwise will be writted to the directory specified in `output-dir`.

```bash
# Output to stdout
# Write MySQL schema to ./tablename_schema.json
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
Copyright (c) 2015 Arjun Mehta
```
