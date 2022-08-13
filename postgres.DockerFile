FROM postgres as database

RUN -itd -e POSTGRES_USER=testboi -e POSTGRES_PASSWORD=testboi -p 5432:5432
