{:oc =>
  { :i18n =>
    { :plural =>
      { :keys => [:one, :other],
        :rule => lambda { |n|
          if n == 1
            :one
          else
            :other
          end
        }
      }
    }
  }
}
