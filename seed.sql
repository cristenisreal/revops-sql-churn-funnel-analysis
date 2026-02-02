INSERT INTO customers VALUES
(1,'Oakridge LTC','LTC','2025-09-01','CompetitorA'),
(2,'Pineview LTC','LTC','2025-10-10',NULL),
(3,'BrightSmile Dental','Dental','2025-08-15','CompetitorB'),
(4,'Evergreen Schools','Schools','2025-11-01',NULL);

INSERT INTO shifts VALUES
(101,1,'2025-12-01',1,1200),
(102,1,'2025-12-08',1,1100),
(103,1,'2026-01-05',0,0),
(201,2,'2025-12-03',1,900),
(202,2,'2026-01-03',1,950),
(203,2,'2026-01-24',1,980),
(301,3,'2025-11-20',1,700),
(302,3,'2025-12-20',0,0),
(303,3,'2026-01-20',0,0),
(401,4,'2025-12-15',1,500),
(402,4,'2026-01-15',1,520);

INSERT INTO experiments VALUES
(1,'Outbound_Email_Subject_Test','A','2026-01-01','2026-01-31'),
(2,'Outbound_Email_Subject_Test','B','2026-01-01','2026-01-31');

INSERT INTO events VALUES
(1,1,'2026-01-02 09:00','email_sent',1,'A'),
(2,1,'2026-01-02 10:00','email_open',1,'A'),
(3,1,'2026-01-03 14:00','email_reply',1,'A'),
(4,2,'2026-01-02 09:05','email_sent',2,'B'),
(5,2,'2026-01-02 09:30','email_open',2,'B'),
(6,3,'2026-01-05 11:00','email_sent',1,'A'),
(7,3,'2026-01-05 11:20','email_open',1,'A'),
(8,4,'2026-01-06 08:00','email_sent',2,'B');
