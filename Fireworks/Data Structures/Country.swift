//
//  Country.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/21/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

struct Country {
    
    static let all = [
        Country(name: "United States", flag: #imageLiteral(resourceName: "United_States"),
                fact: "Annually on the 4th of July, the United States celebrates their independence from Britain in 1776. People gather together in crowds to watch fireworks and enjoy some time spent with their family and friends."),
        Country(name: "Japan", flag: #imageLiteral(resourceName: "Japan"), fact: "Throughout August, Japan celebrates its history through firework displays. These displays have become a competition, starting from their humble beginning in the 18th century and growing into the massive displays in Tokyo by the Sumida River."),
        Country(name: "United Kingdom", flag: #imageLiteral(resourceName: "United_Kingdom"), fact: "The United Kingdom celebrates Guy Fawkes Night every November 5th in honor of putting a stop to the attempted murder of King James I on November 5, 1605."),
        Country(name: "Singapore", flag: #imageLiteral(resourceName: "Singapore"), fact: "Ever since 2004, Singapore has held a yearly firework display in Marina Bay to celebrate its history and national principles."),
        Country(name: "Peru", flag: #imageLiteral(resourceName: "Peru"), fact: "Throughout South America, Christmas is celebrated with tiny fireworks known as \"little stars.\" Villages come together and form fountains out of these \"little stars\". For Christmas dinner, it is custom to eat turkey sandwiches and drink pineapple juice."),
        Country(name: "United Arab Emirates", flag: #imageLiteral(resourceName: "united-arab-emirates"), fact: "In Dubai, the Muslim community celebrates the end of Ramadan with multiple firework displays."),
        Country(name: "Switzerland", flag: #imageLiteral(resourceName: "Switzerland"), fact: "Switzerland annually celebrates its national values on August 1st."),
        Country(name: "India", flag: #imageLiteral(resourceName: "India"), fact: "From October to November, India celebrates Diwali with The Festival of Lights. Families come together and fires are lit in clay pots to ward off any evil spirits."),
        Country(name: "China", flag: #imageLiteral(resourceName: "China"), fact: "During the first weekend of February, China celebrates the Chines New Year with red and yellow firework displays, dragon costumes, and the Lantern Festivals."),
        Country(name: "France", flag: #imageLiteral(resourceName: "France"), fact: "Annually on July 14th, France celebrates the French revolution through firework displays. Paris holds the most exciting display of all, around the Eiffel Tower."),
        Country(name: "Hungary", flag: #imageLiteral(resourceName: "Hungary"), fact: "Hungary holds a firework display every year on August 20th to celebrate the nation and its values."),
        Country(name: "Malta", flag: #imageLiteral(resourceName: "Malta"), fact: "Fireworks have been used throughout the history of Malta. When St. John was in charge, any important event or election involved a fireworks display."),
        Country(name: "Costa Rica", flag: #imageLiteral(resourceName: "Costa_Rica"), fact: "Costa Rica has a tradition of using fireworks to celebrate weddings.")
    ]
    
    let name: String
    let flag: UIImage
    let fact: String
}
