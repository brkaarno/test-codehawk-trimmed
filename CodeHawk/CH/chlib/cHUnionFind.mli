(* =============================================================================
   CodeHawk Abstract Interpretation Engine
   Author: Arnaud Venet
   ------------------------------------------------------------------------------
   The MIT License (MIT)
 
   Copyright (c) 2005-2019 Kestrel Technology LLC

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:
 
   The above copyright notice and this permission notice shall be included in all
   copies or substantial portions of the Software.
  
   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.
  ------------------------------------------------------------------------------ *)

module Make :
  functor (E : CHCommon.STOREABLE) ->
    sig
      module C :
        sig
          module ObjectMap :
            sig
              type key = E.t
              type 'a t = 'a Map.Make(E).t
              val empty : 'a t
              val is_empty : 'a t -> bool
              val mem : key -> 'a t -> bool
              val add : key -> 'a -> 'a t -> 'a t
              val singleton : key -> 'a -> 'a t
              val remove : key -> 'a t -> 'a t
              val merge :
                (key -> 'a option -> 'b option -> 'c option) ->
                'a t -> 'b t -> 'c t
              val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
              val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
              val iter : (key -> 'a -> unit) -> 'a t -> unit
              val fold : (key -> 'a -> 'b -> 'b) -> 'a t -> 'b -> 'b
              val for_all : (key -> 'a -> bool) -> 'a t -> bool
              val exists : (key -> 'a -> bool) -> 'a t -> bool
              val filter : (key -> 'a -> bool) -> 'a t -> 'a t
              val partition : (key -> 'a -> bool) -> 'a t -> 'a t * 'a t
              val cardinal : 'a t -> int
              val bindings : 'a t -> (key * 'a) list
              val min_binding : 'a t -> key * 'a
              val max_binding : 'a t -> key * 'a
              val choose : 'a t -> key * 'a
              val split : key -> 'a t -> 'a t * 'a option * 'a t
              val find : key -> 'a t -> 'a
              val map : ('a -> 'b) -> 'a t -> 'b t
              val mapi : (key -> 'a -> 'b) -> 'a t -> 'b t
            end
          module ObjectSet :
            sig
              type elt = E.t
              type t = Set.Make(E).t
              val empty : t
              val is_empty : t -> bool
              val mem : elt -> t -> bool
              val add : elt -> t -> t
              val singleton : elt -> t
              val remove : elt -> t -> t
              val union : t -> t -> t
              val inter : t -> t -> t
              val diff : t -> t -> t
              val compare : t -> t -> int
              val equal : t -> t -> bool
              val subset : t -> t -> bool
              val iter : (elt -> unit) -> t -> unit
              val fold : (elt -> 'a -> 'a) -> t -> 'a -> 'a
              val for_all : (elt -> bool) -> t -> bool
              val exists : (elt -> bool) -> t -> bool
              val filter : (elt -> bool) -> t -> t
              val partition : (elt -> bool) -> t -> t * t
              val cardinal : t -> int
              val elements : t -> elt list
              val min_elt : t -> elt
              val max_elt : t -> elt
              val choose : t -> elt
              val split : elt -> t -> t * bool * t
            end
          class set_t :
            object ('a)
              val mutable count : int
              val mutable objectSet : ObjectSet.t
              method add : ObjectSet.elt -> unit
	      method choose: ObjectSet.elt option
              method addList : ObjectSet.elt list -> unit
              method addSet : 'a -> unit
              method clone : 'a
              method diff : 'a -> 'a
              method equal : 'a -> bool
              method filter : (ObjectSet.elt -> bool) -> 'a
              method fold : ('b -> ObjectSet.elt -> 'b) -> 'b -> 'b
              method has : ObjectSet.elt -> bool
              method inter : 'a -> 'a
              method isEmpty : bool
              method iter : (ObjectSet.elt -> unit) -> unit
              method private mkNew : 'a
              method remove : ObjectSet.elt -> unit
              method removeList : ObjectSet.elt list -> unit
              method singleton : ObjectSet.elt option
              method size : int
              method subset : 'a -> bool
              method toList : ObjectSet.elt list
              method toPretty : CHPretty.pretty_t
              method union : 'a -> 'a
            end
          class ['a] simple_table_t :
            object ('b)
              val mutable count : int
              val mutable table : 'a ObjectMap.t
              method clone : 'b
              method fold : ('c -> ObjectMap.key -> 'a -> 'c) -> 'c -> 'c
              method get : ObjectMap.key -> 'a option
              method has : ObjectMap.key -> bool
              method iter : (ObjectMap.key -> 'a -> unit) -> unit
              method keys : set_t
              method listOfKeys : ObjectSet.elt list
              method listOfPairs : (ObjectMap.key * 'a) list
              method listOfValues : 'a list
              method map : ('a -> 'a) -> 'b
              method mapi : (ObjectMap.key -> 'a -> 'a) -> 'b
              method private mkNew : 'b
              method remove : ObjectMap.key -> unit
              method removeList : ObjectMap.key list -> unit
              method set : ObjectMap.key -> 'a -> unit
              method setOfKeys : set_t
              method size : int
            end
          class ['a] table_t :
            object ('b)
              constraint 'a = < toPretty : CHPretty.pretty_t; .. >
              val mutable count : int
              val mutable table : 'a ObjectMap.t
              method clone : 'b
              method fold : ('c -> ObjectMap.key -> 'a -> 'c) -> 'c -> 'c
              method get : ObjectMap.key -> 'a option
              method has : ObjectMap.key -> bool
              method iter : (ObjectMap.key -> 'a -> unit) -> unit
              method keys : set_t
              method listOfKeys : ObjectSet.elt list
              method listOfPairs : (ObjectMap.key * 'a) list
              method listOfValues : 'a list
              method map : ('a -> 'a) -> 'b
              method mapi : (ObjectMap.key -> 'a -> 'a) -> 'b
              method private mkNew : 'b
              method remove : ObjectMap.key -> unit
              method removeList : ObjectMap.key list -> unit
              method set : ObjectMap.key -> 'a -> unit
              method setOfKeys : set_t
              method size : int
              method toPretty : CHPretty.pretty_t
            end
          val set_of_list : ObjectSet.elt list -> set_t
        end
      class uf_node_t :
        C.ObjectMap.key ->
        uf_node_table_t ->
        object ('a)
          val mutable parent : C.ObjectMap.key
          val mutable rank : int
          method element : C.ObjectMap.key
          method findSet : uf_node_t
          method incRank : unit
          method link : 'a -> unit
          method parent : C.ObjectMap.key
          method rank : int
          method setParent : C.ObjectMap.key -> unit
          method union : 'a -> unit
        end
      and uf_node_table_t : [uf_node_t] C.simple_table_t
      class union_find_t :
        object
          val mutable uf_node_table : uf_node_table_t
          method find : C.ObjectMap.key -> C.ObjectMap.key
          method private getSet : C.ObjectMap.key -> uf_node_t
          method reset : unit
          method union : C.ObjectMap.key -> C.ObjectMap.key -> unit
        end
      class virtual ['a] union_find_with_attributes_t :
        object
          val mutable attribute_table : 'a C.simple_table_t
          val mutable uf_node_table : uf_node_table_t
          method find : C.ObjectMap.key -> C.ObjectMap.key
          method get : C.ObjectMap.key -> 'a option
          method private getSet : C.ObjectMap.key -> uf_node_t
          method virtual mergeAttributes : 'a -> 'a -> 'a
          method reset : unit
          method set : C.ObjectMap.key -> 'a -> unit
          method union : C.ObjectMap.key -> C.ObjectMap.key -> unit
        end
    end
