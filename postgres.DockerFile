FROM postgres:15 as database

RUN -itd -e POSTGRES_USER=testboi -e POSTGRES_PASSWORD=testboi -p 5432:5432
