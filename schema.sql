-- ==============================================================================
-- 1. CLEANUP
-- ==============================================================================
DROP TABLE IF EXISTS pyqs CASCADE;
DROP TABLE IF EXISTS notes CASCADE;
DROP TABLE IF EXISTS qbank CASCADE;
DROP TABLE IF EXISTS syllabus CASCADE;
DROP TABLE IF EXISTS pyq_years CASCADE;
DROP TABLE IF EXISTS exams CASCADE;

-- ==============================================================================
-- 2. TABLE CREATION
-- ==============================================================================

CREATE TABLE exams (
    id SERIAL PRIMARY KEY,
    short_name VARCHAR(10) UNIQUE NOT NULL,
    paper VARCHAR(150) NOT NULL,
    exam_date DATE NOT NULL,
    exam_day VARCHAR(20) NOT NULL,
    start_time VARCHAR(20) NOT NULL,
    end_time VARCHAR(20) NOT NULL,
    credits INT NOT NULL,
    color VARCHAR(10),
    dim VARCHAR(10),
    txt VARCHAR(10)
);

CREATE TABLE pyq_years (
    id SERIAL PRIMARY KEY,
    year_range VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE syllabus (
    id SERIAL PRIMARY KEY,
    exam_short_name VARCHAR(10) REFERENCES exams(short_name) ON DELETE CASCADE,
    unit_order INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    topics JSONB NOT NULL
);

CREATE TABLE qbank (
    id SERIAL PRIMARY KEY,
    exam_short_name VARCHAR(10) REFERENCES exams(short_name) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    pages INT,
    tag VARCHAR(50),
    upd VARCHAR(50),
    icon VARCHAR(50),
    color VARCHAR(10),
    dim VARCHAR(10),
    src_link TEXT -- Resource link
);

CREATE TABLE notes (
    id SERIAL PRIMARY KEY,
    exam_short_name VARCHAR(10) REFERENCES exams(short_name) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    pages INT,
    tag VARCHAR(50),
    upd VARCHAR(50),
    icon VARCHAR(50),
    color VARCHAR(10),
    dim VARCHAR(10),
    src_link TEXT -- Resource link
);

-- New Table to explicitly manage which PYQs you actually have
CREATE TABLE pyqs (
    id SERIAL PRIMARY KEY,
    exam_short_name VARCHAR(10) REFERENCES exams(short_name) ON DELETE CASCADE,
    year_range VARCHAR(20) REFERENCES pyq_years(year_range) ON DELETE CASCADE,
    src_link TEXT NOT NULL -- Resource link
);

-- ==============================================================================
-- 3. ROW LEVEL SECURITY (RLS) - PUBLIC READ ACCESS
-- ==============================================================================

ALTER TABLE exams ENABLE ROW LEVEL SECURITY;
ALTER TABLE pyq_years ENABLE ROW LEVEL SECURITY;
ALTER TABLE syllabus ENABLE ROW LEVEL SECURITY;
ALTER TABLE qbank ENABLE ROW LEVEL SECURITY;
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE pyqs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read access on exams" ON exams FOR SELECT USING (true);
CREATE POLICY "Allow public read access on pyq_years" ON pyq_years FOR SELECT USING (true);
CREATE POLICY "Allow public read access on syllabus" ON syllabus FOR SELECT USING (true);
CREATE POLICY "Allow public read access on qbank" ON qbank FOR SELECT USING (true);
CREATE POLICY "Allow public read access on notes" ON notes FOR SELECT USING (true);
CREATE POLICY "Allow public read access on pyqs" ON pyqs FOR SELECT USING (true);

-- ==============================================================================
-- 4. DATA INSERTION (Mock Data)
-- ==============================================================================

INSERT INTO exams (short_name, paper, exam_date, exam_day, start_time, end_time, credits, color, dim, txt) VALUES
('FA-V', 'Financial Accounting - V', '2026-10-06', 'Tuesday', '02:30 p.m.', '04:30 p.m.', 4, '#1A73E8', '#E8F0FE', '#1967D2'),
('DIT-I', 'Direct and Indirect Tax - I', '2026-10-07', 'Wednesday', '02:30 p.m.', '04:30 p.m.', 4, '#EA4335', '#FCE8E6', '#C5221F'),
('IKS', 'Indian Knowledge System in Accounting & Finance', '2026-10-08', 'Thursday', '02:30 p.m.', '03:30 p.m.', 2, '#34A853', '#E6F4EA', '#137333'),
('CFR-I', 'Corporate Financial Reporting - I', '2026-10-09', 'Friday', '02:30 p.m.', '04:30 p.m.', 4, '#F9AB00', '#FEF7E0', '#B06000'),
('SRS', 'Sustainability Reporting and Standards', '2026-10-12', 'Monday', '02:30 p.m.', '03:30 p.m.', 2, '#34A853', '#E6F4EA', '#137333'),
('FMM', 'Fundamentals of Marketing Management', '2026-10-16', 'Friday', '10:30 a.m.', '12:30 p.m.', 4, '#A142F4', '#F3E8FD', '#7B1FA2');

INSERT INTO pyq_years (year_range) VALUES ('2024–25'), ('2023–24'), ('2022–23');

-- Insert ONLY the PYQs you actually have
INSERT INTO pyqs (exam_short_name, year_range, src_link) VALUES
('FA-V', '2024–25', 'https://pdfobject.com/pdf/sample.pdf'),
('DIT-I', '2024–25', 'https://pdfobject.com/pdf/sample.pdf'),
('FA-V', '2023–24', 'https://pdfobject.com/pdf/sample.pdf'),
('CFR-I', '2023–24', 'https://pdfobject.com/pdf/sample.pdf');
