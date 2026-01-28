require "test_helper"

module RapidlyBuilt
  module Toolkit
    class MiddlewareTest < ActiveSupport::TestCase
      # Test middleware classes
      class TestMiddlewareA
        def initialize(*args, &block)
          @args = args
          @block = block
        end

        def call(args)
          args + [ :a ]
        end
      end

      class TestMiddlewareB
        def initialize(*args, &block)
          @args = args
          @block = block
        end

        def call(args)
          args + [ :b ]
        end
      end

      class TestMiddlewareC
        def initialize(*args, &block)
          @args = args
          @block = block
        end

        def call(args)
          args + [ :c ]
        end
      end

      setup do
        @stack = Middleware.new
      end

      test "#use adds middleware to the end of the stack" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareB

        assert_equal 2, @stack.size
        result = @stack.call([])
        assert_equal [ :a, :b ], result
      end

      test "#use returns self for chaining" do
        result = @stack.use(TestMiddlewareA).use(TestMiddlewareB)
        assert_equal @stack, result
        assert_equal 2, @stack.size
      end

      test "#use passes arguments to middleware constructor" do
        middleware_class = Class.new do
          attr_reader :arg1, :arg2

          def initialize(arg1, arg2)
            @arg1 = arg1
            @arg2 = arg2
          end

          def call(args)
            args
          end
        end

        @stack.use middleware_class, :arg1, :arg2
        entry = @stack.entries.first
        middleware = entry.instance

        assert_equal :arg1, middleware.arg1
        assert_equal :arg2, middleware.arg2
      end

      test "#use passes block to middleware constructor" do
        block_called = false
        middleware_class = Class.new do
          attr_reader :block

          def initialize(&block)
            @block = block
          end

          def call(args)
            @block.call if @block
            args
          end
        end

        @stack.use(middleware_class) { block_called = true }
        entry = @stack.entries.first
        middleware = entry.instance

        assert_not_nil middleware.block
        middleware.block.call
        assert block_called
      end

      test "#insert adds middleware at specific index" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareC
        @stack.insert 1, TestMiddlewareB

        result = @stack.call([])
        assert_equal [ :a, :b, :c ], result
      end

      test "#insert_before inserts middleware before target" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareC
        @stack.insert_before TestMiddlewareC, TestMiddlewareB

        result = @stack.call([])
        assert_equal [ :a, :b, :c ], result
      end

      test "#insert_before raises error if target not found" do
        @stack.use TestMiddlewareA

        assert_raises ArgumentError do
          @stack.insert_before TestMiddlewareC, TestMiddlewareB
        end
      end

      test "#insert_after inserts middleware after target" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareC
        @stack.insert_after TestMiddlewareA, TestMiddlewareB

        result = @stack.call([])
        assert_equal [ :a, :b, :c ], result
      end

      test "#insert_after raises error if target not found" do
        @stack.use TestMiddlewareA

        assert_raises ArgumentError do
          @stack.insert_after TestMiddlewareC, TestMiddlewareB
        end
      end

      test "#swap replaces middleware" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareB
        @stack.swap TestMiddlewareB, TestMiddlewareC

        result = @stack.call([])
        assert_equal [ :a, :c ], result
      end

      test "#swap raises error if target not found" do
        @stack.use TestMiddlewareA

        assert_raises ArgumentError do
          @stack.swap TestMiddlewareC, TestMiddlewareB
        end
      end

      test "#delete removes middleware without raising" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareB
        @stack.delete TestMiddlewareA

        assert_equal 1, @stack.size
        result = @stack.call([])
        assert_equal [ :b ], result
      end

      test "#delete does not raise if middleware not found" do
        @stack.use TestMiddlewareA
        @stack.delete TestMiddlewareB

        assert_equal 1, @stack.size
      end

      test "#delete! removes middleware and raises if not found" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareB
        @stack.delete! TestMiddlewareA

        assert_equal 1, @stack.size

        assert_raises ArgumentError do
          @stack.delete! TestMiddlewareC
        end
      end

      test "#unshift adds middleware to beginning" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareB
        @stack.unshift TestMiddlewareC

        result = @stack.call([])
        assert_equal [ :c, :a, :b ], result
      end

      test "#size returns number of middleware" do
        assert_equal 0, @stack.size
        @stack.use TestMiddlewareA
        assert_equal 1, @stack.size
        @stack.use TestMiddlewareB
        assert_equal 2, @stack.size
      end

      test "#each iterates over entries" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareB

        entries = []
        @stack.each { |entry| entries << entry.klass }

        assert_equal [ TestMiddlewareA, TestMiddlewareB ], entries
      end

      test "#each returns self" do
        @stack.use TestMiddlewareA
        result = @stack.each { |_entry| }
        assert_equal @stack, result
      end

      test "#move moves middleware to specific index" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareB
        @stack.use TestMiddlewareC
        @stack.move TestMiddlewareC, 0

        result = @stack.call([])
        assert_equal [ :c, :a, :b ], result
      end

      test "#move raises error if target not found" do
        @stack.use TestMiddlewareA

        assert_raises ArgumentError do
          @stack.move TestMiddlewareC, 0
        end
      end

      test "#move_after moves middleware after target" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareB
        @stack.use TestMiddlewareC
        @stack.move_after TestMiddlewareC, TestMiddlewareA

        result = @stack.call([])
        assert_equal [ :a, :c, :b ], result
      end

      test "#move_after raises error if target not found" do
        @stack.use TestMiddlewareA

        assert_raises ArgumentError do
          @stack.move_after TestMiddlewareB, TestMiddlewareC
        end
      end

      test "#move_before moves middleware before target" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareB
        @stack.use TestMiddlewareC
        @stack.move_before TestMiddlewareC, TestMiddlewareA

        result = @stack.call([])
        assert_equal [ :c, :a, :b ], result
      end

      test "#move_before raises error if target not found" do
        @stack.use TestMiddlewareA

        assert_raises ArgumentError do
          @stack.move_before TestMiddlewareB, TestMiddlewareC
        end
      end

      test "#call chains middleware in order" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareB
        @stack.use TestMiddlewareC

        result = @stack.call([])
        assert_equal [ :a, :b, :c ], result
      end

      test "#call passes args through chain" do
        middleware_class = Class.new do
          def call(args)
            args + [ 1 ]
          end
        end

        @stack.use middleware_class
        @stack.use middleware_class

        result = @stack.call([ :initial ])
        assert_equal [ :initial, 1, 1 ], result
      end

      test "find_index works with class" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareB

        index = @stack.send(:find_index, TestMiddlewareB)
        assert_equal 1, index
      end

      test "find_index works with string class name" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareB

        index = @stack.send(:find_index, "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareB")
        assert_equal 1, index
      end

      test "find_index works with short class name" do
        @stack.use TestMiddlewareA
        @stack.use TestMiddlewareB

        index = @stack.send(:find_index, "TestMiddlewareB")
        assert_equal 1, index
      end

      test "find_index returns nil if not found" do
        @stack.use TestMiddlewareA

        index = @stack.send(:find_index, TestMiddlewareB)
        assert_nil index
      end

      # String class name (lazy loading) tests

      test "#use accepts string class name for lazy loading" do
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareA"
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareB"

        assert_equal 2, @stack.size
        result = @stack.call([])
        assert_equal [ :a, :b ], result
      end

      test "#use with string class name resolves class lazily" do
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareA"

        entry = @stack.entries.first
        # klass_or_name should still be a string
        assert_equal "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareA", entry.klass_or_name
        # klass should resolve to the actual class
        assert_equal TestMiddlewareA, entry.klass
      end

      test "#use with string passes arguments to middleware constructor" do
        middleware_class = Class.new do
          attr_reader :arg1, :arg2

          def initialize(arg1, arg2)
            @arg1 = arg1
            @arg2 = arg2
          end

          def call(args)
            args
          end
        end

        # Define the class with a constant name so we can reference it as a string
        self.class.const_set(:TestMiddlewareWithArgs, middleware_class) unless self.class.const_defined?(:TestMiddlewareWithArgs)

        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareWithArgs", :arg1, :arg2
        entry = @stack.entries.first
        middleware = entry.instance

        assert_equal :arg1, middleware.arg1
        assert_equal :arg2, middleware.arg2
      end

      test "mixed class and string registration works" do
        @stack.use TestMiddlewareA
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareB"
        @stack.use TestMiddlewareC

        result = @stack.call([])
        assert_equal [ :a, :b, :c ], result
      end

      test "#insert_before works with string-registered middleware" do
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareA"
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareC"
        @stack.insert_before "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareC", TestMiddlewareB

        result = @stack.call([])
        assert_equal [ :a, :b, :c ], result
      end

      test "#insert_after works with string-registered middleware" do
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareA"
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareC"
        @stack.insert_after "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareA", TestMiddlewareB

        result = @stack.call([])
        assert_equal [ :a, :b, :c ], result
      end

      test "#swap works with string-registered middleware" do
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareA"
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareB"
        @stack.swap "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareB", TestMiddlewareC

        result = @stack.call([])
        assert_equal [ :a, :c ], result
      end

      test "#delete works with string-registered middleware" do
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareA"
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareB"
        @stack.delete "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareA"

        assert_equal 1, @stack.size
        result = @stack.call([])
        assert_equal [ :b ], result
      end

      test "#each works with string-registered middleware" do
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareA"
        @stack.use TestMiddlewareB

        classes = []
        @stack.each { |entry| classes << entry.klass }

        assert_equal [ TestMiddlewareA, TestMiddlewareB ], classes
      end

      test "find_index works with class when middleware registered as string" do
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareA"
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareB"

        index = @stack.send(:find_index, TestMiddlewareB)
        assert_equal 1, index
      end

      test "find_index works with short name when middleware registered as string" do
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareA"
        @stack.use "RapidlyBuilt::Toolkit::MiddlewareTest::TestMiddlewareB"

        index = @stack.send(:find_index, "TestMiddlewareB")
        assert_equal 1, index
      end

      test "generates a new instance every time when reload_classes? is true" do
        RapidlyBuilt.config.with reload_classes: true do
          @stack.use TestMiddlewareA
          @stack.use TestMiddlewareB

          instance1 = @stack.entries.first.instance
          instance2 = @stack.entries.first.instance
          assert_not_same instance1, instance2
        end
      end
    end
  end
end
