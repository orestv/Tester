-- phpMyAdmin SQL Dump
-- version 3.4.5deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 15, 2012 at 12:24 AM
-- Server version: 5.1.61
-- PHP Version: 5.3.6-13ubuntu3.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `tests`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`application`@`%` PROCEDURE `create_test`(
name VARCHAR(255),
topic_ids VARCHAR(512),
is_final BOOLEAN)
BEGIN

END$$

--
-- Functions
--
CREATE DEFINER=`application`@`%` FUNCTION `TestResult`(attemptId INT) RETURNS float
BEGIN
    DECLARE result INT;
    IF attemptId IS NULL THEN RETURN -1;
    END IF;
    SELECT SUM(points) INTO result FROM (
        SELECT ta.id AS test_attempt_id, q.id AS question_id, 
        CASE WHEN q.multiselect
            THEN SUM( CASE WHEN (a.correct = 1 AND sa.id IS NOT NULL)
                             OR (a.correct = 0 AND sa.id IS NULL)
                            THEN 1 ELSE 0 END
                ) / COUNT(a.id)
        ELSE        
            SUM(CASE WHEN a.correct = 1 AND sa.id IS NOT NULL THEN 1 ELSE 0 END)
        END AS points
        FROM test_attempt ta
        INNER JOIN test t 
            ON ta.test_id = t.id
        INNER JOIN question_sequence qs 
            ON qs.test_id = t.id AND (qs.student_id IS NULL OR qs.student_id = ta.student_id)
        INNER JOIN question_sequence_questions qsq 
            ON qsq.sequence_id = qs.id
        INNER JOIN question q 
            ON qsq.question_id = q.id
        INNER JOIN answer a 
            ON a.question_id = q.id
        LEFT OUTER JOIN student_answer sa ON sa.test_attempt_id = ta.id AND sa.answer_id = a.id
        GROUP BY ta.id, q.id
        ORDER BY q.id
    ) pts
    INNER JOIN test_attempt ta
        ON pts.test_attempt_id = ta.id
    WHERE ta.id = attemptId;
    RETURN result;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `answer`
--

CREATE TABLE IF NOT EXISTS `answer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) NOT NULL,
  `text` varchar(2048) COLLATE utf8_unicode_ci NOT NULL,
  `correct` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=346 ;

--
-- Dumping data for table `answer`
--

INSERT INTO `answer` (`id`, `question_id`, `text`, `correct`) VALUES
(314, 67, 'PaCO2 28 мм рт.ст., РаО2 96 мм рт.ст.', 1),
(320, 68, 'Електрокардіографія', 0),
(345, 73, 'Яка з біса Австрія, якщо лампа кінця дев’яностих?', 0),
(322, 68, 'Газовий аналіз артеріальної крові', 0),
(340, 72, 'Багато', 0),
(321, 68, 'Пульсоксиметрія', 0),
(344, 73, 'Тому що це Австрія.', 1),
(341, 72, 'варіантів', 0),
(342, 72, 'Відповіді', 0),
(343, 73, 'А біс його знає.', 0),
(316, 67, 'РаСО2 66 мм рт.ст., РаО2 55 мм рт.ст.', 0),
(315, 67, 'РаСО2 42 мм рт.ст., РаО2 54 мм рт.ст.', 0),
(312, 66, 'РаСО2 10 мм рт.ст., РаО2 60 мм рт.ст.', 0),
(313, 66, 'РаСО2 40 мм рт.ст., SpO2 80%', 0),
(311, 66, 'РаСО2 42 мм рт.ст., РаО2 54 мм рт.ст.', 0),
(310, 66, 'PaCO2 28 мм рт.ст., РаО2 96 мм рт.ст.', 0),
(306, 65, 'У плазмі крові', 0),
(307, 65, 'У альвеолах та в еритроцитах', 0),
(308, 65, 'У дихальних шляхах', 0),
(309, 66, 'РаСО2 66 мм рт.ст., РаО2 55 мм рт.ст.', 1),
(338, 72, 'Відсутній', 0),
(339, 72, 'Зміст', 1),
(336, 72, 'Переклад', 0),
(337, 72, 'Однозначно', 0),
(335, 71, 'Мадемуазель-Міледі', 1),
(334, 71, 'Іосиф', 0),
(333, 71, 'Декарт, Рене', 0),
(332, 71, 'Рене Декарт', 0),
(331, 70, 'Де є вихід?!', 0),
(330, 70, 'Відкрити панель "Пуск"', 0),
(302, 64, 'Близько 6 л', 0),
(303, 64, 'Близько 4 мл', 0),
(304, 65, 'У альвеолах', 1),
(305, 65, 'У еритроцитах', 0),
(300, 64, 'Близько 3,2 мл', 0),
(301, 64, 'Близько 12 л', 0),
(298, 63, 'Збільшити концентрацію севофлурану на випаровувачі й на певний час відключити адсорбер', 0),
(299, 64, 'Близько 320 мл', 1),
(297, 63, 'Збільшити концентрацію севофлурану на випаровувачі й на певний час збільшити хвилинний об''єм вентиляції', 0),
(295, 63, 'Збільшити концентрацію севофлурану на випаровувачі й на певний час зменшити потік свіжої суміші', 0),
(296, 63, 'Збільшити концентрацію севофлурану на випаровувачі й на певний час збільшити частоту дихання', 0),
(294, 63, 'Збільшити концентрацію севофлурану на випаровувачі й на певний час збільшити потік свіжої суміші', 1),
(293, 62, 'Збільшити дихальний об''єм, не змінюючи частоту дихання', 0),
(292, 62, 'Зменшити потік кисню на ротаметрі', 0),
(289, 62, 'Збільшити хвилинний об''єм вентиляції', 1),
(290, 62, 'Зменшити хвилинни об''єм вентиляції', 0),
(291, 62, 'Збільшити потік кисню на ротаметрі', 0),
(319, 68, 'Капнографія', 1),
(318, 67, 'РаСО2 40 мм рт.ст., SpO2 80%', 0),
(317, 67, 'РаСО2 38 мм рт.ст., РаО2 150 мм рт.ст.', 0),
(329, 70, 'Щоб плювати всім на голови', 1),
(328, 70, 'Щоб побачити небо', 1),
(327, 69, 'Стопудово', 0),
(325, 69, 'Ні', 1),
(326, 69, 'Можливо', 1),
(324, 69, 'Так', 0),
(323, 68, 'Газова оксиметрія', 0);

-- --------------------------------------------------------

--
-- Table structure for table `question`
--

CREATE TABLE IF NOT EXISTS `question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_id` int(11) NOT NULL,
  `text` varchar(4096) COLLATE utf8_unicode_ci NOT NULL,
  `comment` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL,
  `multiselect` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=74 ;

--
-- Dumping data for table `question`
--

INSERT INTO `question` (`id`, `topic_id`, `text`, `comment`, `multiselect`) VALUES
(66, 11, 'Які з перелічених показників свідчать про гіповентиляцію (пацієнт дихає повітрям)?', NULL, 0),
(68, 11, 'Яким із перелічених методів найраніше буде виявлено інтраопераційну зупинку кровообігу по типу електромеханічної дисоціації?', NULL, 0),
(67, 11, 'Які з перелічених показників свідчать про гіпервентиляцію?', NULL, 0),
(64, 11, 'Скільки кисню споживає організм дорослої людини масою тіла 80 кг за 1 хвилину?', NULL, 0),
(65, 11, 'Преоксигенація проводиться для профілактики гіпоксії під час апное. Де створюється запас кисню під час преоксигенації 100% киснем?', NULL, 0),
(62, 11, 'Під час інгаляційної низькопоточної анестезії зафіксовано поступове зростання PetCO2 до 50 мм.рт.ст. Як слід скоригувати параметри, щоб показник повернувся до норми?', NULL, 0),
(63, 11, 'Під час інгаляційної низькопоточної анестезії виникла потреба у швидкому поглибленні анестезії. Яких заходів слід вжити?', NULL, 0),
(72, 12, 'Where in the World is Carmen Sandiego?', NULL, 0),
(73, 12, 'Чому ця лампа не підтримує лампочки, яскравіші за сорок ватт?', 'чортівня якась', 0),
(69, 12, 'Чи бувають живі овочі?', 'Хто придумав цю маячню?!', 1),
(70, 12, 'Нащо людям літати?', NULL, 1),
(71, 12, 'Як звали Рене Декарта?', 'три мушкетери, так!', 0);

-- --------------------------------------------------------

--
-- Table structure for table `question_sequence`
--

CREATE TABLE IF NOT EXISTS `question_sequence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `test_id` int(11) NOT NULL,
  `student_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=4 ;

--
-- Dumping data for table `question_sequence`
--

INSERT INTO `question_sequence` (`id`, `test_id`, `student_id`) VALUES
(1, 1, NULL),
(2, 2, 1),
(3, 3, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `question_sequence_questions`
--

CREATE TABLE IF NOT EXISTS `question_sequence_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sequence_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `order` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=24 ;

--
-- Dumping data for table `question_sequence_questions`
--

INSERT INTO `question_sequence_questions` (`id`, `sequence_id`, `question_id`, `order`) VALUES
(1, 1, 64, 1),
(2, 1, 62, 2),
(3, 1, 72, 3),
(4, 1, 66, 4),
(5, 1, 65, 5),
(6, 1, 71, 6),
(7, 2, 65, 1),
(8, 2, 62, 2),
(9, 2, 63, 3),
(10, 2, 64, 4),
(11, 2, 66, 5),
(12, 2, 67, 6),
(13, 2, 68, 7),
(14, 3, 64, 1),
(15, 3, 70, 2),
(16, 3, 65, 3),
(17, 3, 73, 4),
(18, 3, 72, 5),
(19, 3, 62, 6),
(20, 3, 67, 7),
(21, 3, 66, 8),
(22, 3, 68, 9),
(23, 3, 63, 10);

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE IF NOT EXISTS `student` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `lastname` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `hash` char(40) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=3 ;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`id`, `firstname`, `lastname`, `email`, `hash`) VALUES
(1, 'Orest', 'Voloshchuk', 'orest.v@gmail.com', '567948122aa5d4c7c8eb8b8c2c7af85cf6537dde'),
(2, 'Voloshchuk', 'Rostyslav', 'rostykv@gmail.com', '3c66bad09687e02523a657c5fae385278cb90de7');

-- --------------------------------------------------------

--
-- Table structure for table `student_answer`
--

CREATE TABLE IF NOT EXISTS `student_answer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `test_attempt_id` int(11) NOT NULL,
  `answer_id` int(11) NOT NULL,
  `stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=42 ;

--
-- Dumping data for table `student_answer`
--

INSERT INTO `student_answer` (`id`, `student_id`, `test_attempt_id`, `answer_id`, `stamp`) VALUES
(1, 1, 1, 300, '2012-03-10 18:54:53'),
(2, 1, 1, 293, '2012-03-10 18:54:55'),
(3, 1, 1, 339, '2012-03-10 18:54:56'),
(4, 1, 1, 311, '2012-03-10 18:54:58'),
(5, 1, 1, 307, '2012-03-10 18:54:59'),
(6, 1, 1, 335, '2012-03-10 18:55:01'),
(7, 1, 2, 299, '2012-03-10 18:55:09'),
(8, 1, 2, 293, '2012-03-10 18:55:12'),
(9, 1, 2, 339, '2012-03-10 18:55:16'),
(10, 1, 2, 312, '2012-03-10 18:55:18'),
(11, 1, 2, 304, '2012-03-10 18:55:20'),
(12, 1, 2, 335, '2012-03-10 18:55:22'),
(13, 1, 3, 300, '2012-03-10 18:55:29'),
(14, 1, 3, 290, '2012-03-10 18:55:30'),
(15, 1, 3, 338, '2012-03-10 18:55:32'),
(16, 1, 3, 310, '2012-03-10 18:55:34'),
(17, 1, 3, 308, '2012-03-10 18:55:36'),
(18, 1, 3, 333, '2012-03-10 18:55:38'),
(19, 1, 4, 299, '2012-03-13 19:15:28'),
(20, 1, 4, 289, '2012-03-13 19:15:30'),
(21, 1, 4, 340, '2012-03-13 19:15:32'),
(22, 1, 4, 311, '2012-03-13 19:15:34'),
(23, 1, 4, 304, '2012-03-13 19:15:36'),
(24, 1, 4, 335, '2012-03-13 19:15:39'),
(25, 1, 5, 300, '2012-03-13 19:15:50'),
(26, 1, 5, 331, '2012-03-13 19:15:53'),
(27, 1, 5, 330, '2012-03-13 19:15:53'),
(28, 1, 5, 304, '2012-03-13 19:15:54'),
(29, 1, 5, 344, '2012-03-13 19:15:56'),
(30, 1, 5, 342, '2012-03-13 19:15:59'),
(31, 1, 5, 293, '2012-03-13 19:16:01'),
(32, 1, 5, 315, '2012-03-13 19:16:03'),
(33, 1, 5, 311, '2012-03-13 19:16:04'),
(34, 1, 5, 321, '2012-03-13 19:16:06'),
(35, 1, 5, 295, '2012-03-13 19:16:09'),
(36, 1, 6, 303, '2012-03-13 19:50:09'),
(37, 1, 6, 293, '2012-03-13 19:50:10'),
(38, 1, 6, 341, '2012-03-13 19:50:12'),
(39, 1, 6, 311, '2012-03-13 19:50:14'),
(40, 1, 6, 304, '2012-03-13 19:50:15'),
(41, 1, 6, 333, '2012-03-13 19:50:16');

-- --------------------------------------------------------

--
-- Table structure for table `test`
--

CREATE TABLE IF NOT EXISTS `test` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `final` tinyint(1) NOT NULL DEFAULT '0',
  `questionCount` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=4 ;

--
-- Dumping data for table `test`
--

INSERT INTO `test` (`id`, `name`, `final`, `questionCount`) VALUES
(1, 'Тест', 0, 6),
(2, 'Контрольний з медицини', 1, 7),
(3, 'Пробний по всьому - 10', 0, 10);

-- --------------------------------------------------------

--
-- Table structure for table `test_attempt`
--

CREATE TABLE IF NOT EXISTS `test_attempt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `test_id` int(11) NOT NULL,
  `start` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end` timestamp NULL DEFAULT NULL,
  `result` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=7 ;

--
-- Dumping data for table `test_attempt`
--

INSERT INTO `test_attempt` (`id`, `student_id`, `test_id`, `start`, `end`, `result`) VALUES
(1, 1, 1, '2012-03-10 18:54:50', '2012-03-10 18:55:01', 2),
(2, 1, 1, '2012-03-10 18:55:05', '2012-03-10 18:55:22', 4),
(3, 1, 1, '2012-03-10 18:55:27', '2012-03-10 18:55:38', 0),
(4, 1, 1, '2012-03-13 19:15:25', '2012-03-13 19:15:39', 4),
(5, 1, 3, '2012-03-13 19:15:48', '2012-03-13 19:16:09', 2),
(6, 1, 1, '2012-03-13 19:50:04', '2012-03-13 19:52:10', 1);

-- --------------------------------------------------------

--
-- Table structure for table `test_topics`
--

CREATE TABLE IF NOT EXISTS `test_topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `test_id` int(11) NOT NULL,
  `topic_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=6 ;

--
-- Dumping data for table `test_topics`
--

INSERT INTO `test_topics` (`id`, `test_id`, `topic_id`) VALUES
(1, 1, 11),
(2, 1, 12),
(3, 2, 11),
(4, 3, 11),
(5, 3, 12);

-- --------------------------------------------------------

--
-- Table structure for table `topic`
--

CREATE TABLE IF NOT EXISTS `topic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(512) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=13 ;

--
-- Dumping data for table `topic`
--

INSERT INTO `topic` (`id`, `name`) VALUES
(12, 'Невідомо що'),
(11, 'Медичне');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
