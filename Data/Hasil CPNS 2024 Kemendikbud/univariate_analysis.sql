/*
Univariate Analysis
This is the first attempt to perform univariate analysis on cleaned table.
The analyses focuses on descriptive statistics grouped by:
(1) last_edu, (2) job_posiiton, and (3) birthdate.

count, min, mean, max, vrc, stddev
*/ 

/* 1. Univarate analysis on last_edu */
SELECT 
	last_edu,
    COUNT(last_edu) AS count_le,
    -- TWK
    MIN(twk) AS min_twk, ROUND(AVG(twk), 2) AS avg_twk, MAX(twk) AS max_twk, 
    ROUND(VAR_SAMP(twk), 2) AS varc_twk, ROUND(STDDEV_SAMP(twk), 2) AS stdev_twk,
    
    -- TIU
    MIN(tiu) AS min_tiu, ROUND(AVG(tiu), 2) AS avg_tiu, MAX(tiu) AS max_tiu, 
    ROUND(VAR_SAMP(tiu), 2) AS varc_tiu, ROUND(STDDEV_SAMP(tiu), 2) AS stdev_tiu,
    
    -- TKP
    MIN(tkp) AS min_tkp, ROUND(AVG(tkp), 2) AS avg_tkp, MAX(tkp) AS max_tkp, 
    ROUND(VAR_SAMP(tkp), 2) AS varc_tkp, ROUND(STDDEV_SAMP(tkp), 2) AS stdev_tkp,
    
    -- SKD
    MIN(skd) AS min_skd, ROUND(AVG(skd), 2) AS avg_skd, MAX(skd) AS max_skd, 
    ROUND(VAR_SAMP(skd), 2) AS varc_skd, ROUND(STDDEV_SAMP(skd), 2) AS stdev_skd,
    
    -- SKD40
    MIN(skd40) AS min_skd40, ROUND(AVG(skd40), 2) AS avg_skd40, MAX(skd40) AS max_skd40, 
    ROUND(VAR_SAMP(skd40), 2) AS varc_skd40, ROUND(STDDEV_SAMP(skd40), 2) AS stdev_skd40,
    
    -- SKB
    MIN(skb) AS min_skb, ROUND(AVG(skb), 2) AS avg_skb, MAX(skb) AS max_skb, 
    ROUND(VAR_SAMP(skb), 2) AS varc_skb, ROUND(STDDEV_SAMP(skb), 2) AS stdev_skb,
    
    -- SKB60
    MIN(skb60) AS min_skb60, ROUND(AVG(skb60), 2) AS avg_skb60, MAX(skb60) AS max_skb60, 
    ROUND(VAR_SAMP(skb60), 2) AS varc_skb60, ROUND(STDDEV_SAMP(skb60), 2) AS stdev_skb60,
    
    -- FINAL_SCORE
    MIN(final_score) AS min_final, ROUND(AVG(final_score), 2) AS avg_final, MAX(final_score) AS max_final, 
    ROUND(VAR_SAMP(final_score), 2) AS varc_final, ROUND(STDDEV_SAMP(final_score), 2) AS stdev_final
FROM cleaned
WHERE last_edu IS NOT NULL
GROUP BY last_edu
ORDER BY count_le DESC;

/* 2. Univariate on job_position */
SELECT 
	job_position,
    COUNT(job_position) AS count_jp,
    -- TWK
    MIN(twk) AS min_twk, ROUND(AVG(twk), 2) AS avg_twk, MAX(twk) AS max_twk, 
    ROUND(VAR_SAMP(twk), 2) AS varc_twk, ROUND(STDDEV_SAMP(twk), 2) AS stdev_twk,
    
    -- TIU
    MIN(tiu) AS min_tiu, ROUND(AVG(tiu), 2) AS avg_tiu, MAX(tiu) AS max_tiu, 
    ROUND(VAR_SAMP(tiu), 2) AS varc_tiu, ROUND(STDDEV_SAMP(tiu), 2) AS stdev_tiu,
    
    -- TKP
    MIN(tkp) AS min_tkp, ROUND(AVG(tkp), 2) AS avg_tkp, MAX(tkp) AS max_tkp, 
    ROUND(VAR_SAMP(tkp), 2) AS varc_tkp, ROUND(STDDEV_SAMP(tkp), 2) AS stdev_tkp,
    
    -- SKD
    MIN(skd) AS min_skd, ROUND(AVG(skd), 2) AS avg_skd, MAX(skd) AS max_skd, 
    ROUND(VAR_SAMP(skd), 2) AS varc_skd, ROUND(STDDEV_SAMP(skd), 2) AS stdev_skd,
    
    -- SKD40
    MIN(skd40) AS min_skd40, ROUND(AVG(skd40), 2) AS avg_skd40, MAX(skd40) AS max_skd40, 
    ROUND(VAR_SAMP(skd40), 2) AS varc_skd40, ROUND(STDDEV_SAMP(skd40), 2) AS stdev_skd40,
    
    -- SKB
    MIN(skb) AS min_skb, ROUND(AVG(skb), 2) AS avg_skb, MAX(skb) AS max_skb, 
    ROUND(VAR_SAMP(skb), 2) AS varc_skb, ROUND(STDDEV_SAMP(skb), 2) AS stdev_skb,
    
    -- SKB60
    MIN(skb60) AS min_skb60, ROUND(AVG(skb60), 2) AS avg_skb60, MAX(skb60) AS max_skb60, 
    ROUND(VAR_SAMP(skb60), 2) AS varc_skb60, ROUND(STDDEV_SAMP(skb60), 2) AS stdev_skb60,
    
    -- FINAL_SCORE
    MIN(final_score) AS min_final, ROUND(AVG(final_score), 2) AS avg_final, MAX(final_score) AS max_final, 
    ROUND(VAR_SAMP(final_score), 2) AS varc_final, ROUND(STDDEV_SAMP(final_score), 2) AS stdev_final
FROM cleaned
WHERE job_position IS NOT NULL
GROUP BY job_position
ORDER BY count_jp DESC;

/* 3. Univariate analysis on birthdate grouped by generation classification
Classification:
1. Baby Boomer = 1946 - 1964
2. Gen X = 1965 - 1980
3. Gen Y (Millenial) = 1981 - 1996
4. Gen Z = 1997 - 2012
5. Gen Alpha >= 2013 (But impossible)
*/

SELECT 
    CASE 
        WHEN YEAR(birthdate) BETWEEN 1946 AND 1964 THEN 'Baby Boomer'
        WHEN YEAR(birthdate) BETWEEN 1965 AND 1980 THEN 'Gen X'
        WHEN YEAR(birthdate) BETWEEN 1981 AND 1996 THEN 'Gen Y (Millennial)'
        WHEN YEAR(birthdate) BETWEEN 1997 AND 2012 THEN 'Gen Z'
        WHEN YEAR(birthdate) >= 2013 THEN 'Gen Alpha'
        ELSE 'Unknown'
    END AS generation,
    COUNT(*) AS total_candidates,

    -- TWK Stats
    MIN(twk) AS min_twk, ROUND(AVG(twk), 2) AS avg_twk, MAX(twk) AS max_twk, 
    ROUND(VAR_SAMP(twk), 2) AS varc_twk, ROUND(STDDEV_SAMP(twk), 2) AS stdev_twk,
    
    -- TIU Stats
    MIN(tiu) AS min_tiu, ROUND(AVG(tiu), 2) AS avg_tiu, MAX(tiu) AS max_tiu, 
    ROUND(VAR_SAMP(tiu), 2) AS varc_tiu, ROUND(STDDEV_SAMP(tiu), 2) AS stdev_tiu,
    
    -- TKP Stats
    MIN(tkp) AS min_tkp, ROUND(AVG(tkp), 2) AS avg_tkp, MAX(tkp) AS max_tkp, 
    ROUND(VAR_SAMP(tkp), 2) AS varc_tkp, ROUND(STDDEV_SAMP(tkp), 2) AS stdev_tkp,

    -- FINAL_SCORE Stats
    MIN(final_score) AS min_final, ROUND(AVG(final_score), 2) AS avg_final, MAX(final_score) AS max_final, 
    ROUND(VAR_SAMP(final_score), 2) AS varc_final, ROUND(STDDEV_SAMP(final_score), 2) AS stdev_final

FROM cleaned
WHERE birthdate IS NOT NULL
GROUP BY generation
ORDER BY MIN(birthdate) ASC;

/* 4. Count of open job position with no candidate */
SELECT
	job_position,
    COUNT(job_position) AS total_count,
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS count_no_cand
FROM cleaned
GROUP BY job_position
ORDER BY total_count DESC;

##############################################
#
#
#		Custom query goes below
#
#############################################

SELECT 
	last_edu,
	job_position,
    COUNT(job_position) AS count_jp,
    -- TWK
    MIN(twk) AS min_twk, ROUND(AVG(twk), 2) AS avg_twk, MAX(twk) AS max_twk, 
    ROUND(VAR_SAMP(twk), 2) AS varc_twk, ROUND(STDDEV_SAMP(twk), 2) AS stdev_twk,
    
    -- TIU
    MIN(tiu) AS min_tiu, ROUND(AVG(tiu), 2) AS avg_tiu, MAX(tiu) AS max_tiu, 
    ROUND(VAR_SAMP(tiu), 2) AS varc_tiu, ROUND(STDDEV_SAMP(tiu), 2) AS stdev_tiu,
    
    -- TKP
    MIN(tkp) AS min_tkp, ROUND(AVG(tkp), 2) AS avg_tkp, MAX(tkp) AS max_tkp, 
    ROUND(VAR_SAMP(tkp), 2) AS varc_tkp, ROUND(STDDEV_SAMP(tkp), 2) AS stdev_tkp,
    
    -- SKD
    MIN(skd) AS min_skd, ROUND(AVG(skd), 2) AS avg_skd, MAX(skd) AS max_skd, 
    ROUND(VAR_SAMP(skd), 2) AS varc_skd, ROUND(STDDEV_SAMP(skd), 2) AS stdev_skd,
    
    -- SKD40
    MIN(skd40) AS min_skd40, ROUND(AVG(skd40), 2) AS avg_skd40, MAX(skd40) AS max_skd40, 
    ROUND(VAR_SAMP(skd40), 2) AS varc_skd40, ROUND(STDDEV_SAMP(skd40), 2) AS stdev_skd40,
    
    -- SKB
    MIN(skb) AS min_skb, ROUND(AVG(skb), 2) AS avg_skb, MAX(skb) AS max_skb, 
    ROUND(VAR_SAMP(skb), 2) AS varc_skb, ROUND(STDDEV_SAMP(skb), 2) AS stdev_skb,
    
    -- SKB60
    MIN(skb60) AS min_skb60, ROUND(AVG(skb60), 2) AS avg_skb60, MAX(skb60) AS max_skb60, 
    ROUND(VAR_SAMP(skb60), 2) AS varc_skb60, ROUND(STDDEV_SAMP(skb60), 2) AS stdev_skb60,
    
    -- FINAL_SCORE
    MIN(final_score) AS min_final, ROUND(AVG(final_score), 2) AS avg_final, MAX(final_score) AS max_final, 
    ROUND(VAR_SAMP(final_score), 2) AS varc_final, ROUND(STDDEV_SAMP(final_score), 2) AS stdev_final
FROM cleaned
WHERE 
	job_position IS NOT NULL AND
	job_position LIKE "DOSEN%" AND
    last_edu LIKE "%PENDIDIKAN BAHASA INGGRIS"
GROUP BY job_position, last_edu
ORDER BY count_jp DESC;