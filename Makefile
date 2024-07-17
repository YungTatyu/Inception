IMAGE_NAME	:= alpine-image
RM	:= rm -f

all: build

build:
	docker build --no-cache -t ${IMAGE_NAME} .

run: build
	docker run -it ${IMAGE_NAME}

clean:
	${RM} ${IMAGE_NAME}


.PHONY : all build run clean fclean
