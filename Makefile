NAME		=	ft_turing

CAMLC		=	ocamlc
CAMLOPT		=	ocamlopt
CAMLDEP		=	ocamldep


##
##		FILE DESCRIPTOR
##

SRCS =	Machine.mli \
		Machine.ml \
		Parse.ml \
		main.ml

##
##		DEPENDENCE DESCRIPTOR
##

OBJS = $(SRCS:.ml=.cmo)
OBJIS = $(SRCS:.mli=.cmi)
OBJOPT = $(SRCS:.ml=.cmx)

##
##		RULES
##

all:	depend $(NAME)

$(NAME): byt opt
	ln -s $(NAME).byt $(NAME)

opt:		$(NAME).opt
byt:		$(NAME).byt

$(NAME).byt:	$(OBJS)
	ocamlfind $(CAMLC) -linkpkg -thread -package yojson -I +str str.cma -o $(NAME).byt $(OBJS)

$(NAME).opt:	$(OBJOPT)
	ocamlfind $(CAMLOPT) -linkpkg -thread -thread -package yojson -I +str str.cmxa -o $(NAME).opt $(OBJOPT)

##
##		OCAML FILES
##

.SUFFIXES:	.ml .mli .cmo .cmi .cmx

.mli.cmi:
	ocamlfind $(CAMLC) -thread -package yojson -I +str str.cma -c $<

.ml.cmo:
	ocamlfind $(CAMLC) -thread -package yojson -I +str str.cma -c $<

.ml.cmx:
	ocamlfind $(CAMLOPT) -thread -package yojson -I +str str.cmxa -c $<

##
##		CLEANING 
##

clean:
	rm -rf *.cm[iox] *.o

fclean: clean
	rm -rf $(NAME) $(NAME).byt $(NAME).opt

$(OBJ_PATH):
	mkdir $(OBJ_PATH)

re:			fclean all

install:
	brew install opam
	opam switch create 5.1.0
	opam init
	eval $(opam env --switch=5.1.0)
	opam install yojson -y
	opam install core -y
	eval $(opam env --switch=5.1.0)
	opam install ocamlfind -y
	eval $(opam env --switch=5.1.0)

.SILENT:	all $(NAME) fclean clean re 
.PHONY:		clean fclean re

##
##		DEPENDANCIES SETUP
##

depend: .depend
	$(CAMLDEP) $(SRCS) > .depend

include .depend