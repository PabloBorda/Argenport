
CREATE PROCEDURE normalize_products(IN product_id INT)
BEGIN  
    DECLARE current_title VARCHAR(2050);
    DECLARE products_size,counter INT;
    
     select count(*) into products_size from products;
     SET counter = 0;
    
   
    
      WHILE (counter < products_size) DO  
          select title
          into current_title
          from products
          where products.id=counter;
        
          select current_title, filtered_products.id, SUM(sales.amount),AVG(sales.amount)
          from (select id,title,current_title
                from products
                where (levenshtein_ratio(title,current_title)>85)) as filtered_products,sales
          where sales.product = filtered_products.id
          group by sales.product;

          SET counter = counter + 1;  
    END WHILE;

 END;