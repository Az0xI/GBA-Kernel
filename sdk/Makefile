CC	=	ghc
SRC	=	src/qeunelle.hs
OBJ	=	$(SRC:.hs=.o) $(SRC:.hs=.hi)
NAME	=	qeunelle

all:	$(NAME)

$(NAME):
	$(CC) -o $(NAME) $(SRC)

clean:
	rm -f $(OBJ)

fclean:	clean
	rm -f $(NAME)

re:	fclean all

.PHONY: all clean fclean re
