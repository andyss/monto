require "monto/threaded/lifecycle"

module Monto
  module Threaded
    extend self
    
    def begin_execution(name)
      stack(name).push(true)
    end

    def database_override
      Thread.current["[monto]:db-override"]
    end

    def database_override=(name)
      Thread.current["[monto]:db-override"] = name
    end

    def sessions
      Thread.current["[monto]:sessions"] ||= {}
    end

    def executing?(name)
      !stack(name).empty?
    end

    def exit_execution(name)
      stack(name).pop
    end

    def stack(name)
      Thread.current["[monto]:#{name}-stack"] ||= []
    end

    def begin_autosave(document)
      autosaves_for(document.class).push(document.id)
    end

    def begin_validate(document)
      validations_for(document.class).push(document.id)
    end

    def exit_autosave(document)
      autosaves_for(document.class).delete_one(document.id)
    end

    def exit_validate(document)
      validations_for(document.class).delete_one(document.id)
    end

    def session_override
      Thread.current["[monto]:session-override"]
    end

    def session_override=(name)
      Thread.current["[monto]:session-override"] = name
    end

    def scope_stack
      Thread.current["[monto]:scope-stack"] ||= {}
    end

    def autosaved?(document)
      autosaves_for(document.class).include?(document.id)
    end

    def validated?(document)
      validations_for(document.class).include?(document.id)
    end

    def autosaves
      Thread.current["[monto]:autosaves"] ||= {}
    end

    def validations
      Thread.current["[monto]:validations"] ||= {}
    end

    def autosaves_for(klass)
      autosaves[klass] ||= []
    end

    def validations_for(klass)
      validations[klass] ||= []
    end
    
  end
end