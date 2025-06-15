//
//  BurgerBuilder.swift
//  SimpleBuilderPattern
//
//  Created by dan phi on 11/6/25.
//
struct BurgerBuilder {
    private var _name: String = "Burger Tùy Chỉnh"
    private var _patties: Int = 1
    private var _bacon: Bool = false
    private var _cheese: Bool = false
    private var _pickles: Bool = false
    private var _ketchup: Bool = false
    private var _mustard: Bool = false
    private var _lettuce: Bool = false
    private var _tomato: Bool = false

    // Phương thức cài đặt tên burger, trả về builder để chaining
    func withName(_ name: String) -> BurgerBuilder {
        var builder = self
        builder._name = name
        return builder
    }

    // Phương thức cài đặt số lượng miếng thịt, trả về builder để chaining
    func withPatties(_ count: Int) -> BurgerBuilder {
        var builder = self
        builder._patties = count
        return builder
    }

    // Phương thức thêm thịt xông khói, trả về builder để chaining
    func addBacon(_ include: Bool = true) -> BurgerBuilder {
        var builder = self
        builder._bacon = include
        return builder
    }

    // Phương thức thêm phô mai, trả về builder để chaining
    func addCheese(_ include: Bool = true) -> BurgerBuilder {
        var builder = self
        builder._cheese = include
        return builder
    }

    // Phương thức thêm dưa chuột muối, trả về builder để chaining
    func addPickles(_ include: Bool = true) -> BurgerBuilder {
        var builder = self
        builder._pickles = include
        return builder
    }

    // Phương thức thêm sốt cà chua, trả về builder để chaining
    func addKetchup(_ include: Bool = true) -> BurgerBuilder {
        var builder = self
        builder._ketchup = include
        return builder
    }

    // Phương thức thêm mù tạt, trả về builder để chaining
    func addMustard(_ include: Bool = true) -> BurgerBuilder {
        var builder = self
        builder._mustard = include
        return builder
    }

    // Phương thức thêm xà lách, trả về builder để chaining
    func addLettuce(_ include: Bool = true) -> BurgerBuilder {
        var builder = self
        builder._lettuce = include
        return builder
    }

    // Phương thức thêm cà chua, trả về builder để chaining
    func addTomato(_ include: Bool = true) -> BurgerBuilder {
        var builder = self
        builder._tomato = include
        return builder
    }
    
    // Phương thức xây dựng đối tượng Burger cuối cùng
    func build() -> Burger {
        return Burger(name: _name, patties: _patties, bacon: _bacon, cheese: _cheese,
                      pickles: _pickles, ketchup: _ketchup, mustard: _mustard,
                      lettuce: _lettuce, tomato: _tomato)
    }
}
