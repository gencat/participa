module Decidim
    module Type
        module Abilities
            module Admin
            # Defines the abilities related to departments for a logged in admin user.
            # Intended to be used with `cancancan`.
                class AdminAbility < Decidim::Abilities::AdminAbility
                    def define_abilities
                        super
                        can :manage, Type
                    end
                end
            end
        end
    end
end