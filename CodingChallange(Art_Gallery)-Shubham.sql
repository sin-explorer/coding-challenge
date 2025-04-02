create database art_gallery;
use art_gallery;

-- Create the Artists table
CREATE TABLE Artists (
 ArtistID INT PRIMARY KEY,
 Name VARCHAR(255) NOT NULL,
 Biography TEXT,
 Nationality VARCHAR(100));
-- Create the Categories table
CREATE TABLE Categories (
 CategoryID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL);
-- Create the Artworks table
CREATE TABLE Artworks (
 ArtworkID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 ArtistID INT,
 CategoryID INT,
 Year INT,
 Description TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));
-- Create the Exhibitions table
CREATE TABLE Exhibitions (
 ExhibitionID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT);
-- Create a table to associate artworks with exhibitions
CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));
 
 -- Insert sample data into the Artists table
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');
-- Insert sample data into the Categories table
INSERT INTO Categories (CategoryID, Name) VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography');
-- Insert sample data into the Artworks table
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picasso\'s powerful anti-war mural.', 'guernica.jpg');
-- Insert sample data into the Exhibitions table
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');
-- Insert artworks into exhibitions
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2);
 
 
 -- 1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and list them in descending order of the number of artworks.

 select A.Name , Count(Art.ArtworkID) AS ArtworkCount 
 From Artists A 
 Left Join Artworks Art On A.ArtistID=Art.ArtistID
 Group By A.Name 
 Order By ArtworkCount Desc;
 --  2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order them by the year in ascending order.

 Select Art.Title, A.Name, A.Nationality, Art.Year
 From Artworks Art
 Join Artists A On Art.ArtistID = A.ArtistID
 where A.Nationality In ('Spanish','Dutch')
 order by Art.Year Asc;
 -- 3 Find the names of all artists who have artworks in the 'Painting' category, and the number of  artworks they have in this category.
 Select A.Name ,Count(Art.ArtworkID) As ArtworkCount
 From Artists A
 Join Artworks Art On A.ArtistID = Art.ArtistID
 Join Categories C On Art.CategoryID = C.CategoryID
 where C.name ='Painting'
 group by A.name;
-- 4 List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their artists and categories.
 select Art.Title, A.Name as ArtistName, C.Name AS CategoryName 
 From Artworks Art 
 Join ExhibitionArtWorks EA on Art.ArtworkID = EA.ArtworkID
 Join Exhibitions E on EA.ExhibitionID =E.ExhibitionID
 Join Artists  A On Art.ArtistID =A.ArtistID
 Join Categories C on Art.CategoryID=C.CategoryID
 Where E.Title = 'Modern Art Masterpieces';
 -- 5 Find the artists who have more than two artworks in the gallery.
 Select A.name , Count(Art.ArtworkID) As ArtWorkCount
 From Artists A Join Artworks Art on A.ArtistID = Art.ArtistID
 group by A.name
 having count(Art.ArtWorkID)>2;

-- 6 Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 'Renaissance Art' exhibitions
select Art.Title
From Artworks Art
Join ExhibitionArtworks EA1 on Art.ArtworkID = EA1.ArtworkID
Join Exhibitions E1 on EA1.ExhibitionID = E1.ExhibitionID
Join ExhibitionArtworks EA2 on Art.ArtworkID=EA2.ArtworkID
Join Exhibitions E2 on EA2.ExhibitionID = E2.ExhibitionID
Where E1.Title = 'Modern Art Masterpieces' And E2.Title= 'Renaissance Art';

-- 7 Find the total number of artworks in each category
select C.name As CategoryName , Count(Art.ArtworkID) AS TotalArtworks 
From Categories C 
Left join Artworks art on c.CategoryID = Art.CategoryID
Group By C.name ;

-- 8 List artists who have more than 3 artworks in the gallery.
select A.Name , Count(ARt.ArtworkID) AS ArtworkCount
From Artists A 
Join Artworks ARt ON A.ArtistID =Art.ArtistID
group by A.Name 
having count(art.artworkid )>3;
-- 9 List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.
select art.title, a.name ,a.nationality
from artworks art
join artists a on art.artistID = A.ArtistID
Where a.nationality ='Spanish';

-- 10 List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.
select E.Title 
from Exhibitions E
Join ExhibitionArtworks EA on E.ExhibitionID = EA.exhibitionID
Join Artworks Art on EA.ArtworkID = Art.ArtworkID
Join Artists A on Art.ArtistID = A.ArtistID
where A.Name in ('Vincent van Gogh','Leonardo da Vinci')
group  by E.Title
having count(distinct A.Name) =2; 

-- 11  Find all the artworks that have not been included in any exhibition.
select Art.Title 
from Artworks art
Left join ExhibitionArtWorks EA on Art.ArtworkId =EA.ArtworkID
Where EA.ExhibitionID is Null;

-- 12 List artists who have created artworks in all available categories.
select A.Name 
from Artists A 
Join Artworks Art on A.ArtistId = Art.ArtistID
Join Categories C on Art.CategoryID = C.CategoryID
group by A.name
having count(distinct c.categoryID)=(select count(*) from Categories);

-- 13 List the total number of artworks in each category.
select C.name As CategoryName , Count(Art.ArtworkID) AS TotalArtworks 
From Categories C 
Left join Artworks art on c.CategoryID = Art.CategoryID
Group By C.name ;

-- 14  Find the artists who have more than 2 artworks in the gallery.
Select A.name , Count(Art.ArtworkID) As ArtWorkCount
 From Artists A Join Artworks Art on A.ArtistID = Art.ArtistID
 group by A.name
 having count(Art.ArtWorkID)>2;
 
 -- 15 List the categories with the average year of artworks they contain, only for categories with more than 1 artwork.
 
 select C.name As CategoryName, avg(Art.Year) as AvgYear
 From Categories C 
 Join ArtWorks Art on C.CategoryId = Art.CategoryID
 group by C.Name 
 having count(art.ArtworkID)>1; 
 
 -- 16 Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.
 select Art.Title 
 from ArtWorks Art
 Join ExhibitionArtwork EA on Art.ArtworkId = EA.ArtworkId
Join Exhibitions E on EA.ExhibitionID = E.ExhibitonId
  Where E.Title = 'Modern Art Masterpieces';
  
  -- 17 Find the categories where the average year of artworks is greater than the average year of all artworks.
  select C.Name As CategoryName , avg(art.year) as avgCategoryYear
  From Categories C 
  Join Artworks art on c.categoryID = Art.CategoryID
  Group by C.Name 
  having Avg(art.year) > (select avg(year) from Artworks );
  
  -- 18 List the artworks that were not exhibited in any exhibition.
  
  select Art.Title 
from Artworks art
Left join ExhibitionArtWorks EA on Art.ArtworkId =EA.ArtworkID
Where EA.ExhibitionID is Null;

-- 19 Show artists who have artworks in the same category as "Mona Lisa."
select distinct A.Name 
from artists A 
join Artworks art on A.ArtistId = Art.ArtistId 
where Art.CategoryId = (select categoryId from Artworks where title = 'Mona Lisa ');

-- 20 List the names of artists and the number of artworks they have in the gallery

select A.Name , Count(Art.ArtworkID) AS ArtworkCount 
 From Artists A 
 Left Join Artworks Art On A.ArtistID=Art.ArtistID
 Group By A.Name 
 Order By ArtworkCount Desc;
  

  
  
  
  
  
  
  
  
 






