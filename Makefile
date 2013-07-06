OCAMLC=ocamlfind ocamlc -linkpkg -package netclient,equeue-ssl
GENERATED=json.ml

all: jcdecaux.cmo

%.ml: %.mll
	ocamllex $<

%.cmo: %.ml
	$(OCAMLC) -c $<

clean:
	rm -f *.cm[io] $(GENERATED)

.depend depend:$(GENERATED)
	rm -f .depend
	ocamldep *.ml > .depend

include .depend

