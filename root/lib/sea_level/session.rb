module Mack
  
  # A holder for the session information. This objects gets stored using the Cachetastic system.
  # For more information about how Cachetastic works see the RDoc for that gem.
  # The session cookie name defaults to: _mack_session_id but can be changed using the application_configuration
  # system like such:
  #   mack::session_id: _my_cool_app_sess_id
  class Session
    
    attr_reader :id # The id of the session.
    
    def initialize(id)
      @id = id
      @sess_hash = {}
    end
    
    # Finds what you're looking for in the session, if it exists.
    # If what you're looking for doesn't exist, it returns nil.
    def [](key)
      sess_hash[key.to_sym]
    end
    
    # Sets a value into the session.
    def []=(key, value)
      sess_hash[key.to_sym] = value
    end
    
    private
    attr_reader :sess_hash # :nodoc:
    
  end # Session
  
end # Mack