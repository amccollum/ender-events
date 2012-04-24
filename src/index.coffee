events = if provide then provide('events', {}) else (@['events'] = {})

class events.EventEmitter
    emit: (type) ->
        return false if not (@_events and type of @_events and @_events[type].length)
        args = Array.prototype.slice.call(arguments, 1)
        for listener in @_events[type]
            listener.apply(@, args)
        
        return true

    addListener: (type, listener) ->
        # Avoid recursion by firing the handler first
        @emit('newListener', type, listener)

        @_events or= {}
        if type of @_events
            @_events[type].push(listener)
        else
            @_events[type] = [listener]
        
        return @

    on: @::addListener

    once: (type, listener) ->
        g = =>
            @removeListener(type, g)
            listener.apply(@, arguments)
            
        @on(type, g)
        return @

    removeListener: (type, listener) ->
        if @_events and type of @_events
            for l, i of @_events[type]
                if l == listener
                    @_events[type].splice(i--, 1)

            if @_events[type].length == 0
                delete @_events[type]
    
        return @

    removeAllListeners: (type) ->
        if @_events and type of @_events
            delete @_events[type]
    
        return @
