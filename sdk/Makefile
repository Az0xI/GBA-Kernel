CC	=	ghc
SRC	=	src/qeunelle.hs
OBJ	=	$(SRC:.hs=.o)
NAME	=	qeunelle

all:	$(NAME)

$(NAME):	$(OBJ)
	$(CC) -o $(NAME) $(SRC)

clean:
	rm -f *.o *.hi

fclean:	clean
	rm -f $(NAME)

re:	fclean all

.PHONY: all clean fclean re
