IMAGE_NAME	:= alpine-image
RM	:= rm -f

all: build

re: down build

build:
	# docker build --no-cache -t ${IMAGE_NAME} .
	docker compose up -d --build

run: build
	# docker run -it ${IMAGE_NAME}

clean:
	# ${RM} ${IMAGE_NAME}

down:
	docker compose down --rmi all --volumes


.PHONY : all build run clean fclean
