DCCOMPOSE := docker compose

all: up

re: down up

up:
	${DCCOMPOSE} up -d --build

run: up

down:
	${DCCOMPOSE} down --rmi all --volumes

clean: down

fclean: clean

start:
	${DCCOMPOSE} start

stop:
	${DCCOMPOSE} stop

.PHONY : all run clean fclean up start stop
