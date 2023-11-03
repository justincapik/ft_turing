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
	$(CAMLC) -I +str str.cma -o $(NAME).byt $(OBJS)

$(NAME).opt:	$(OBJOPT)
	$(CAMLOPT) -I +str str.cmxa -o $(NAME).opt $(OBJOPT)

##
##		OCAML FILES
##

.SUFFIXES:	.ml .mli .cmo .cmi .cmx

.mli.cmi:
	$(CAMLC) -I +str str.cma -c $<

.ml.cmo:
	$(CAMLC) -I +str str.cma -c $<

.ml.cmx:
	$(CAMLOPT) -I +str str.cmxa -c $<

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

.SILENT:	all $(NAME) fclean clean re 
.PHONY:		clean fclean re

##
##		DEPENDANCIES SETUP
##

depend: .depend
	$(CAMLDEP) $(SRCS) > .depend

include .depend