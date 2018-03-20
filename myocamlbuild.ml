open Ocamlbuild_plugin ;;
open Command;;(* set the version number of the software in the plugin *) 


let () =
  Options.use_ocamlfind := true ;
  Options.use_menhir := true ;
  (* make_version () *)
;;


let alphaCaml = A"alphaCaml";;

(* the entry point of the plugin *)
let _ =
  dispatch begin function
    | After_rules ->
      flag ["ocaml" ; "compile"] (A "-annot") ;
      flag ["ocaml" ; "compile"] (A "-g") ;
      flag ["ocaml" ; "compile"; "native" ] (S [(A "-inline"); (A "20")]) ;

      (* for alphaCaml *)
      rule "alphaCaml: mla -> ml & mli"
        ~prods:["%.ml"; "%.mli"]
        ~dep:"%.mla"
      begin fun env _build ->
        Cmd(S[alphaCaml; P(env "%.mla")])
      end
    | _ -> ()
  end
