class Bill
    attr_accessor :itemList #list
    attr_accessor :orderNumber #int
    attr_accessor :total 

    def initialize(orderNumber)
        @itemList = Array.new # or just []
        @orderNumber = orderNumber
        @total = 0
    end

    def add_item(item) 
        # puts("got here")
        @itemList << item
        @total += item.cost.to_f
    end
    
    def update_total(change)
        @total += change
    end
    def contains(item)
        for i in @itemList do
            if (i  == item) #then
                return true
            end
        end
        return false
    end

    def display_bill()
        # TODO
        #printf
        printf("Guest Check                         Order:     %d\n", @orderNumber)
        printf("--------------------------------------------------\n")
        for i in @itemList do
            printf("%s                                     %s", i.name, i.pretty_cost)
            if i.name.downcase == "burger" and i.toppings.length >= 1
                printf("\n*")
                for topping in i.toppings do
                    printf(" %s", topping)
                end
            elsif i.name.downcase == "burger of the day" and i.toppings.length >= 1
                printf("\n*")
                for topping in i.toppings do
                    printf(" %s", topping)
                end
            end
            printf("\n")
        end
        printf("--------------------------------------------------\n")
        printf("Total:                                     %s\n", pretty_total)
    end

    def pretty_bill()
        start = ""
        start += sprintf("Guest Check                         Order:     %d\n", @orderNumber)
        start += sprintf("--------------------------------------------------\n")
        for i in @itemList do
            start += sprintf("%s                                     %s", i.name, i.pretty_cost)
            # start += sprintf("Test name: %s", i.name.downcase)
            if i.name.downcase == "burger" and i.toppings.length >= 1
                start += sprintf("\n*")
                for topping in i.toppings do
                    start += sprintf(" %s", topping)
                end
            elsif i.name.downcase == "burger of the day" and i.toppings.length >= 1
                start += sprintf("\n*")
                for topping in i.toppings do
                    start += sprintf(" %s", topping)
                end
            end
            start += sprintf("\n")
        end
        start += sprintf("--------------------------------------------------\n")
        start += sprintf("Total:                                     %s\n", pretty_total)
    end

    # def get_burger_number(number)
    #     # TODO
    #     count = 0
    #     for i in @itemList do
    #         if i.name == "Burger"
    #             count += 1
    #         elsif i.name == "Burger of the day"
    #             count += 1
    #         end
    #     end
    #     return count
    # end

    def pretty_total()
        return sprintf("$%.02f", @total)
    end 
    
    def remove_item(item)
        @itemList.delete(item)
    end

    def total()
        return @total
    end

    def update_order_number(number)
        @orderNumber = number
    end
end

class Item
    attr_accessor :name #not sure
    attr_accessor :cost
    
    def initialize( name, cost ) #copied from the API
        @name = name
        @cost = cost
    end

    def pretty_cost() #copied from the API
        return sprintf( "$%.02f" , @cost )
    end

    def print_cost() #copied from the API
        puts "$%.02f" % @cost
    end

    def update_cost(change) #copied from the API
        @cost += change 
    end

    def update_name(name) #copied from the API
        @name = name
    end
end

class Fries < Item
    def initialize
        super("Fries", 2.00)
    end
end

class Beer < Item
    def initialize
        super("Beer", 4.00)
    end
end

class SoftDrink < Item
    def initialize
        super("Soft Drink", 2.00)
    end
end

class SideSalad < Item
    def initialize
        super("Salad", 2.50)
    end
end

class Cheese < Item
    def initialize
        super("Cheese", 0.50)
    end
end

class BurgerOfTheDay < Item
    attr_accessor :toppings
    def initialize
        super("Burger of the day", 5.95)
        @toppings = Array.new
    end
    def add_topping(item)
        @toppings.push(item)
    end
    def remove_topping(item)
        @toppings.delete(item)
    end
end

class Burger < Item
    attr_accessor :toppings
    def initialize
        super("Burger", 5.00)
        @toppings = Array.new
        # Mustard Ketchup Lettuce Tomato Onion
        @toppings.push("Mustard")
        @toppings.push("Ketchup")
        @toppings.push("Lettuce")
        @toppings.push("Tomato")
        @toppings.push("Onion")
    end
    def add_topping(item)
        @toppings.push(item)
    end
    def remove_topping(item)
        @toppings.delete(item)
    end
end

input = ARGV[0]
output = ARGV[1]

out = File.open(output, "w")

bill = Bill.new(0)
burgerCount = 0
itemCount = 0
# burger = Burger.new
File.readlines(input, chomp: true).each do |line| 
    command = line.split(' ')
    if command[0].downcase == "order"
        bill.update_order_number(command[1])
    elsif command[0].downcase == "add"
        burger = bill.itemList.last#[itemCount - 1]
        if command[1].downcase == "cheese"
            burger.update_cost(0.5)
            burger.add_topping("add")
            bill.update_total(0.5)
        end
        burger.add_topping(command[1].capitalize)
    elsif command[0].downcase == "remove"
        #TODO
        burger = Burger.new()
        burger = bill.itemList.last
        burger.remove_topping(command[1])
    elsif command[0].downcase == "fries"
        fries = Fries.new()
        bill.add_item(fries)
        itemCount += 1
    elsif command[0].downcase == "beer"
        beer = Beer.new()
        bill.add_item(beer)
        itemCount += 1
    elsif command[0].downcase == "drink"
        drink = SoftDrink.new()
        bill.add_item(drink)
        itemCount += 1
    elsif command[0].downcase == "salad"
        salad = SideSalad.new()
        bill.add_item(salad)
        itemCount += 1
    elsif command[0].downcase == "burger"
        if (command.length > 1)
            burgerOfTheDay = BurgerOfTheDay.new()
            bill.add_item(burgerOfTheDay)
        else
            burger = Burger.new()
            bill.add_item(burger)
        end
        burgerCount += 1
        itemCount += 1
    end
end

File.write(out, bill.pretty_bill)
out.close()
