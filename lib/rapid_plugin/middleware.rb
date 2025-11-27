module RapidPlugin
  # Middleware stack that exposes the same API as Rails' ActionDispatch::Middleware::Stack
  # but without any Rack-specific variables (i.e. [status, headers, body]).
  #
  # Each element in the stack implements `#call(args)` and returns exactly `args` so they can be chained together.
  #
  # @example
  #   stack = RapidPlugin::Middleware.new
  #   stack.use MiddlewareA
  #   stack.use MiddlewareB
  #   result = stack.call(initial_args)
  class Middleware
    # Internal class to represent a middleware entry in the stack
    class Entry
      attr_reader :klass, :args, :block, :instance

      def initialize(klass, *args, &block)
        @klass = klass
        @args = args
        @block = block
        @instance = klass.new(*args, &block)
      end
    end

    def initialize
      @entries = []
    end

    # Add a middleware to the end of the stack
    #
    # @param klass [Class] The middleware class
    # @param args [Array] Arguments to pass to the middleware constructor
    # @param block [Proc] Optional block to pass to the middleware constructor
    # @return [self]
    def use(klass, *args, &block)
      @entries << Entry.new(klass, *args, &block)
      self
    end

    # Insert a middleware at a specific index
    #
    # @param index [Integer] The index to insert at
    # @param klass [Class] The middleware class
    # @param args [Array] Arguments to pass to the middleware constructor
    # @param block [Proc] Optional block to pass to the middleware constructor
    # @return [self]
    def insert(index, klass, *args, &block)
      @entries.insert(index, Entry.new(klass, *args, &block))
      self
    end

    # Insert a middleware before another middleware
    #
    # @param target [Class, String] The middleware class or name to insert before
    # @param klass [Class] The middleware class to insert
    # @param args [Array] Arguments to pass to the middleware constructor
    # @param block [Proc] Optional block to pass to the middleware constructor
    # @return [self]
    def insert_before(target, klass, *args, &block)
      index = find_index(target)
      raise ArgumentError, "No such middleware: #{target}" if index.nil?
      insert(index, klass, *args, &block)
    end

    # Insert a middleware after another middleware
    #
    # @param target [Class, String] The middleware class or name to insert after
    # @param klass [Class] The middleware class to insert
    # @param args [Array] Arguments to pass to the middleware constructor
    # @param block [Proc] Optional block to pass to the middleware constructor
    # @return [self]
    def insert_after(target, klass, *args, &block)
      index = find_index(target)
      raise ArgumentError, "No such middleware: #{target}" if index.nil?
      insert(index + 1, klass, *args, &block)
    end

    # Swap an existing middleware with a new one
    #
    # @param target [Class, String] The middleware class or name to swap
    # @param klass [Class] The new middleware class
    # @param args [Array] Arguments to pass to the middleware constructor
    # @param block [Proc] Optional block to pass to the middleware constructor
    # @return [self]
    def swap(target, klass, *args, &block)
      index = find_index(target)
      raise ArgumentError, "No such middleware: #{target}" if index.nil?
      @entries[index] = Entry.new(klass, *args, &block)
      self
    end

    # Delete a middleware from the stack (does not raise if not found)
    #
    # @param target [Class, String] The middleware class or name to delete
    # @return [self]
    def delete(target)
      index = find_index(target)
      @entries.delete_at(index) if index
      self
    end

    # Delete a middleware from the stack (raises if not found)
    #
    # @param target [Class, String] The middleware class or name to delete
    # @return [self]
    # @raise [ArgumentError] if the middleware is not found
    def delete!(target)
      index = find_index(target)
      raise ArgumentError, "No such middleware: #{target}" if index.nil?
      @entries.delete_at(index)
      self
    end

    # Add a middleware to the beginning of the stack
    #
    # @param klass [Class] The middleware class
    # @param args [Array] Arguments to pass to the middleware constructor
    # @param block [Proc] Optional block to pass to the middleware constructor
    # @return [self]
    def unshift(klass, *args, &block)
      @entries.unshift(Entry.new(klass, *args, &block))
      self
    end

    # Get the number of middleware in the stack
    #
    # @return [Integer]
    def size
      @entries.size
    end

    # Iterate over each middleware entry
    #
    # @yield [Entry] Each middleware entry
    # @return [self]
    def each(&block)
      @entries.each(&block)
      self
    end

    # Move a middleware to a specific index
    #
    # @param target [Class, String] The middleware class or name to move
    # @param index [Integer] The target index
    # @return [self]
    # @raise [ArgumentError] if the middleware is not found
    def move(target, index)
      source_index = find_index(target)
      raise ArgumentError, "No such middleware: #{target}" if source_index.nil?
      entry = @entries.delete_at(source_index)
      @entries.insert(index, entry)
      self
    end

    # Move a middleware after another middleware
    #
    # @param target [Class, String] The middleware class or name to move
    # @param after [Class, String] The middleware class or name to move after
    # @return [self]
    # @raise [ArgumentError] if either middleware is not found
    def move_after(target, after)
      after_index = find_index(after)
      raise ArgumentError, "No such middleware: #{after}" if after_index.nil?
      move(target, after_index + 1)
    end

    # Move a middleware before another middleware
    #
    # @param target [Class, String] The middleware class or name to move
    # @param before [Class, String] The middleware class or name to move before
    # @return [self]
    # @raise [ArgumentError] if either middleware is not found
    def move_before(target, before)
      before_index = find_index(before)
      raise ArgumentError, "No such middleware: #{before}" if before_index.nil?
      move(target, before_index)
    end

    # Call the middleware stack with the given arguments
    #
    # @param args [Object] Arguments to pass through the middleware chain
    # @return [Object] The result after passing through all middleware
    def call(args)
      @entries.reduce(args) do |result, entry|
        entry.instance.call(result)
      end
    end

    private

    # Find the index of a middleware in the stack
    #
    # @param target [Class, String] The middleware class or name to find
    # @return [Integer, nil] The index of the middleware, or nil if not found
    def find_index(target)
      @entries.index { |entry| matches?(entry, target) }
    end

    # Check if an entry matches the target
    #
    # @param entry [Entry] The middleware entry
    # @param target [Class, String] The target to match against
    # @return [Boolean]
    def matches?(entry, target)
      if target.is_a?(Class)
        entry.klass == target
      else
        entry.klass.name == target.to_s || entry.klass.name&.split("::")&.last == target.to_s
      end
    end
  end
end

