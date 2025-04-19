import * as Fn from "@dashkite/joy/function"
import * as Time from "@dashkite/joy/time"
import Generic from "@dashkite/generic"
import * as Arr from "@dashkite/joy/array"

$ = ( selector ) -> document.querySelector selector

Log =
  duration: ( action, { duration }) ->
    console.log "%cdominator: 
      #{ action } in
      #{ duration.toFixed 3 }ms",
      "color: cyan;"

Types =

  text: 3

Similarity =

  threshold: 5

  best: ( future, candidates ) ->
    do ({ diff, winner, min, candidate, score } = {}) ->
      winner = undefined
      min = Similarity.threshold
      for candidate in candidates
        if ( future.isEqualNode candidate )
          winner = candidate
          break
        else if ( future.tagName == candidate.tagName )
          score = ( Diff.attributes candidate, future ).length
          if score < min
            winner = candidate
            min = score
      winner

Patch =

  text: ( node, text ) ->
    name: "text"
    specifier: { node, text }
    apply: -> node.textContent = text

  attribute: ( node, name, value ) -> 
    if value?
      name: "attribute"
      specifier: { node, name, value }
      apply: -> node.setAttribute name, value
    else
      name: "remove attribute"
      specifier: { node, name }
      apply: -> node.removeAttribute name
      
  add: ( node, previous, parent ) -> 
    name: "add"
    specifier: { node, previous, parent }
    apply: ->
      if previous?
        previous.after node
      else
        parent.prepend node

  move: ( node, previous, parent ) -> 
    name: "move"
    specifier: { node, previous, parent }
    apply: ->
      if previous?
        if !( previous.nextSibling == node )
          previous.after node
      else
        if !( parent.firstChild == node )
          parent.prepend node

  remove: ( node ) -> 
    name: "remove"
    specifier: { node }
    apply: -> node.remove()

Diff =

  text: ( current, future ) ->
    changed = ( current.nodeType == Types.text ) && 
      ( future.nodeType == Types.text ) &&
      ( current.textContent != future.textContent )
    if changed
      [ Patch.text current, future.textContent ]
    else []

  attributes: ( current, future ) ->
    patches = []
    if current.attributes? && future.attributes?
      for { name, value } from future.attributes
        if (( current.getAttribute name ) != value )
          patches.push Patch.attribute current, name, value
      for { name, value } from current.attributes
        if !( future.hasAttribute name )
          patches.push Patch.attribute current, name
    patches

  nodes: ( current, future ) ->
    if future.isEqualNode current
      []
    else
      [
        ( Diff.text current, future )...
        ( Diff.attributes current, future )...
        ( Diff.trees current, future )...
      ]

  trees: ( current, future ) ->
    patches = []
    cx = Array.from current.childNodes
    fx = if Array.isArray future
      future
    else 
      Array.from future.childNodes
    p = undefined
    for f in fx
      if ( c = Similarity.best f, cx )?
        patches = [ patches..., ( Diff.nodes c, f )... ]
        patches.push Patch.move c, p, current
        p = c
        Arr.remove c, cx
      else
        patches.push Patch.add f, p, current
        p = f
    for c in cx
      patches.push Patch.remove c
    patches

diff = Diff.trees

patch = ( patches ) ->
  do ({ patch } = {}) ->
    for patch in patches
      patch.apply()

export { patch, diff }

flash = Fn.curry Fn.binary do ->

  ( Generic.make "DOM.flash" )
  
    .define [ Node, Node ], ( target, node ) ->
      Log.duration "DOM updated", 
        Time.measure "DOM.flash", ->
          patch diff target, [ node ]
      
    .define [ Node, Array ], ( target, nodes ) ->
      Log.duration "DOM updated", 
        Time.measure "DOM.flash", ->
          patch diff target, nodes

    .define [( -> true ), String ], ( target, source ) ->
      dom = undefined
      Log.duration "HTML parsed", 
        Time.measure "html parse", ->
          dom = Document
            .parseHTMLUnsafe source
            .body
      flash target, dom
        
    .define [ String, ( -> true ) ], ( target, html ) ->
        if ( target = $ target )?
          flash target, html

export { flash }