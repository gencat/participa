module Decidim
  module Department
    module Abilities
      # Defines the abilities related to departments for a logged in admin user.
      # Intended to be used with `cancancan`.
      class AdminUser
        include CanCan::Ability

        attr_reader :user, :context

        def initialize(user, context)
          return unless user && user.role?(:admin)

          # @user = user
          # @context = context

          # can :index, Department
          # can :new, Department
          can :manage, Department
        end
      end
    end
  end
end