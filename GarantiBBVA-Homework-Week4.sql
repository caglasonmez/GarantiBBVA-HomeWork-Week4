/* Country: id, name
Lig: id, adı, id_country(hangi ülkenin ligi)
Takim: id, adı, id_leauge, kuruluş yılı, attığı gol, yediği gol, puan, seviye(1=en üst lig, 2, onun bir
alt ligi gibi)
Oyuncu: id, adı, soyadı, id_team, id_country(nereli), attığı gol
1. Yukarıdaki tabloların create scriptlerini oluşturunuz.*/ 

CREATE TABLE Country (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE League (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    id_country INT,
    FOREIGN KEY (id_country) REFERENCES Country(id)
);

CREATE TABLE Team (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    id_league INT,
    establishment_year INT,
    goals_scored INT,
    goals_conceded INT,
    points INT,
    level INT
);

CREATE TABLE Player (
    id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    id_team INT,
    id_country INT,
    goals_scored INT,
    FOREIGN KEY (id_team) REFERENCES Team(id),
    FOREIGN KEY (id_country) REFERENCES Country(id)
);

/* 2. Bu tabloları dolduran insert scriptler yazınız. Ligi olmayan takım */

INSERT INTO Country (id, name) VALUES
    (1, 'Turkey'),
    (2, 'England'),
    (3, 'Spain'),
    (4, 'Germany'),
    (5, 'Italy'),
    (6, 'France'),
    (7, 'Russia'),
    (8, 'Portugal'),
    (9, 'Ukraine'),
    (10, 'Argentina');


INSERT INTO Lig (name, id_country) VALUES
    ('Süper Lig', 1),
    ('Premier League', 2),
    ('Spain Primera League', 3),
    ('Bundesliga', 4),
    ('Italy Serie A', 5),
    ('France 1st League', 6),
    ('Russian Premier League', 7),
    ('Portugal Premier League', 8),
    ('Ukrainian Premier League', 9),
    ('Argentina Premier League', 10);


INSERT INTO Takim (id, name, id_league, establishment_year, goals_scored, goals_conceded, points, level) VALUES
    (1, 'Galatasaray', 1, 1905, 50, 30, 75, 1),
    (2, 'Fenerbahçe', 1, 1907, 45, 25, 70, 1),
    (3, 'Beşiktaş', 1, 1903, 55, 35, 80, 1),
    (4, 'FC Bayern München', 1, 1900 , 365, 373, 75, 1),
    (5, 'Juventus FC', 1, 1897, 45, 52, 70, 1),
    (6, 'Stade Brestois 29', 1, 1903, 56, 35, 80, 1),
    (7, 'FK Spartak Moskva', 1, 1922, 95, 120, 75, 1),
    (8, 'SL Benfica', 1, 1904, 45, 25, 250, 1),
    (9, 'FK Dinamo Kiev', 1, 1927, 46, 45, 80, 1),
    (10, 'CA Boca Juniors', 1, 1905, 74, 25, 80, 1),



INSERT INTO Oyuncu (id, first_name, last_name, id_team, id_country, goals_scored) VALUES
    (1, 'Arda', 'Turan', 1, 1, 10),
    (2, 'Emre', 'Belözoğlu', 1, 1, 8),
    (3, 'Ozan', 'Tufan', 2, 1, 12),
    (4, 'Manuel', 'Neuer', 1, 1, 10),
    (5, 'Dušan', 'Vlahović', 1, 1, 8),
    (6, 'Karamoko', 'Dembélé', 2, 1, 12),
    (7, 'Quincy ', 'Promes', 1, 1, 10),
    (8, 'Gonçalo', 'Ramos', 1, 1, 8),
    (9, 'Andriy', 'Yarmolenko', 2, 1, 12),
    (10, 'Edinson', 'Cavani', 2, 1, 12),


/* 3. İsmi “Türkiye” olan ülkenin liglerinin listesini getiren scripti yazınız.*/ 

SELECT * FROM League WHERE id_country = (SELECT id FROM Country WHERE name = 'Turkey');

/* 4. İsmi “Türkiye” olan ülkenin takımların listesini getiren scripti yazınız.*/

SELECT * FROM Team WHERE id_league IN (SELECT id FROM League WHERE id_country = (SELECT id FROM Country WHERE name = 'Turkey'));

/*5. İsmi “Türkiye” olan en üst seviyeli ligdeki puan tablosunu getiren scripti yazınız.*/

SELECT * FROM Team WHERE id_league = (SELECT id FROM League WHERE id_country = (SELECT id FROM Country WHERE name = 'Turkey') AND level = 1) ORDER BY points DESC;

/*6. Türkiye liglerindeki puan ortalamalarını gösteren scrpiti yazınız.*/

SELECT id_league, AVG(points) as average_points FROM Team WHERE id_league IN (SELECT id FROM League WHERE id_country = (SELECT id FROM Country WHERE name = 'Turkey')) GROUP BY id_league;

/*7. Bir ligin Gol kralını getiren scprit yazınız. (oyuncu adı, soyadı, takım adı, nereli olduğu)*/

SELECT P.first_name, P.last_name, T.name AS team_name, C.name AS country_name
FROM Player P
JOIN Team T ON P.id_team = T.id
JOIN Country C ON P.id_country = C.id
WHERE P.id_team IN (SELECT id FROM Team WHERE id_league = 'LEAGUE_ID')
ORDER BY P.goals_scored DESC
LIMIT 1;
-- LIGIN_IDSI kısmına aradığınız lig ID'sini yazmalısınız.

/*8. Tüm liglerde attığı gol yediği golden daha küçük olan takımları getiren scripti yazınız.*/

SELECT * FROM Team 
WHERE goals_scored > goals_conceded 
AND 
id_league IN (SELECT id FROM League);

/*9. Bir takımın oyuncularının toplam gol sayısını ve takımın gol sayısını yan yana getiren bir scprit yazınız. (kontrol sorgusu gibi, birisi takım verisi, diğeri oyuncuların toplamı olacak)*/

SELECT T.id, T.name AS team_name, SUM(P.goals_scored) AS total_player_goals, T.goals_scored AS team_goals
FROM Team T
JOIN Player P ON T.id = P.id_team
WHERE T.id = 'TEAM_ID'
GROUP BY T.id, T.name;

