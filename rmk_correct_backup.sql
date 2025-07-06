--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: neondb_owner
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO neondb_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: neondb_owner
--

COMMENT ON SCHEMA public IS '';


--
-- Name: Day; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public."Day" AS ENUM (
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN'
);


ALTER TYPE public."Day" OWNER TO neondb_owner;

--
-- Name: DelegateStatus; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public."DelegateStatus" AS ENUM (
    'CONFIRMED',
    'NOT_CONFIRMED'
);


ALTER TYPE public."DelegateStatus" OWNER TO neondb_owner;

--
-- Name: RoleType; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public."RoleType" AS ENUM (
    'ADMIN',
    'EDITOR',
    'VIEWER'
);


ALTER TYPE public."RoleType" OWNER TO neondb_owner;

--
-- Name: SessionStatus; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public."SessionStatus" AS ENUM (
    'SCHEDULED',
    'COMPLETED',
    'CANCELLED',
    'RESCHEDULED'
);


ALTER TYPE public."SessionStatus" OWNER TO neondb_owner;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Category; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Category" (
    id text NOT NULL,
    name text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Category" OWNER TO neondb_owner;

--
-- Name: Client; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Client" (
    id text NOT NULL,
    name text NOT NULL,
    phone text,
    email text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "contactPersonName" text,
    "tradeLicenseNumber" text,
    "contactPersonPosition" text,
    landline text
);


ALTER TABLE public."Client" OWNER TO neondb_owner;

--
-- Name: Course; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Course" (
    id text NOT NULL,
    title text NOT NULL,
    duration text NOT NULL,
    "isCertified" boolean DEFAULT false NOT NULL,
    "isPublic" boolean DEFAULT true NOT NULL,
    "categoryId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    shortname text
);


ALTER TABLE public."Course" OWNER TO neondb_owner;

--
-- Name: DailyNote; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."DailyNote" (
    id text NOT NULL,
    date date NOT NULL,
    note text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."DailyNote" OWNER TO neondb_owner;

--
-- Name: Delegate; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Delegate" (
    id text NOT NULL,
    "sessionId" text NOT NULL,
    name text NOT NULL,
    "emiratesId" text NOT NULL,
    phone text NOT NULL,
    email text NOT NULL,
    "companyName" text NOT NULL,
    "isCorporate" boolean NOT NULL,
    "photoUrl" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "seatId" text NOT NULL,
    status text NOT NULL,
    "clientId" text,
    paid boolean,
    quotation text
);


ALTER TABLE public."Delegate" OWNER TO neondb_owner;

--
-- Name: Language; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Language" (
    id text NOT NULL,
    name text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Language" OWNER TO neondb_owner;

--
-- Name: Location; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Location" (
    id text NOT NULL,
    name text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "deliveryApproach" text,
    emirate text NOT NULL,
    "locationType" text,
    "zoomLink" text,
    "backgroundColor" text DEFAULT '#dbeafe'::text,
    "textColor" text DEFAULT '#1f3a8a'::text
);


ALTER TABLE public."Location" OWNER TO neondb_owner;

--
-- Name: PasswordResetToken; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."PasswordResetToken" (
    id text NOT NULL,
    "userId" text NOT NULL,
    token text NOT NULL,
    "expiresAt" timestamp(3) without time zone NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."PasswordResetToken" OWNER TO neondb_owner;

--
-- Name: Room; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Room" (
    id text NOT NULL,
    name text NOT NULL,
    capacity integer,
    "locationId" text NOT NULL,
    notes text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Room" OWNER TO neondb_owner;

--
-- Name: Trainer; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Trainer" (
    id text NOT NULL,
    name text NOT NULL,
    email text,
    phone text,
    "locationId" text,
    "availableDays" public."Day"[],
    "timeSlots" jsonb,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "dailyTimeSlots" jsonb
);


ALTER TABLE public."Trainer" OWNER TO neondb_owner;

--
-- Name: TrainerLeave; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."TrainerLeave" (
    id text NOT NULL,
    "trainerId" text NOT NULL,
    reason text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "endDate" timestamp(3) without time zone NOT NULL,
    "startDate" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."TrainerLeave" OWNER TO neondb_owner;

--
-- Name: TrainerSchedulingRule; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."TrainerSchedulingRule" (
    id text NOT NULL,
    "trainerId" text NOT NULL,
    "maxSessionsPerDay" integer NOT NULL,
    "daysOff" public."Day"[],
    "allowOverlap" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."TrainerSchedulingRule" OWNER TO neondb_owner;

--
-- Name: TrainingSession; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."TrainingSession" (
    id text NOT NULL,
    "courseId" text NOT NULL,
    "roomId" text NOT NULL,
    date timestamp(3) without time zone NOT NULL,
    "startTime" timestamp(3) without time zone NOT NULL,
    "endTime" timestamp(3) without time zone NOT NULL,
    "locationId" text,
    participants integer,
    notes text,
    "selectedSeats" jsonb,
    "trainerId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    language text,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."TrainingSession" OWNER TO neondb_owner;

--
-- Name: User; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."User" (
    id text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    phone text,
    role public."RoleType" DEFAULT 'VIEWER'::public."RoleType" NOT NULL,
    password text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "firstName" text,
    "lastName" text,
    "phoneNumber" text
);


ALTER TABLE public."User" OWNER TO neondb_owner;

--
-- Name: _CourseLanguages; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."_CourseLanguages" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_CourseLanguages" OWNER TO neondb_owner;

--
-- Name: _TrainerCourses; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."_TrainerCourses" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_TrainerCourses" OWNER TO neondb_owner;

--
-- Name: _TrainerLanguages; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."_TrainerLanguages" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_TrainerLanguages" OWNER TO neondb_owner;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO neondb_owner;

--
-- Data for Name: Category; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Category" (id, name, "createdAt", "updatedAt") FROM stdin;
b9ff9325-6d3f-4a7b-ae6c-f9c47283df4c	Food Safety	2025-05-13 16:09:17.775	2025-05-13 16:09:17.775
5bb5a834-497f-4102-9840-c758a30801af	Catering	2025-05-15 12:42:45.877	2025-05-15 12:42:45.877
229e1ed4-7e1e-41e2-baef-d80509d0dcac	Retail	2025-05-15 12:42:56.357	2025-05-15 12:42:56.357
5f0f339e-985b-4b0e-9d0d-e89f20036d6c	Manufacturing	2025-05-15 12:43:12.056	2025-05-15 12:43:12.056
ac073444-9c6e-4f47-af9b-7c86a45a8fee	Animal Production (Slaughterhouse)	2025-05-15 12:43:30.136	2025-05-15 12:43:30.136
33b0f3ad-3b46-4947-bea3-19ad03d48804	General (Low Risk)	2025-05-16 03:58:27.272	2025-05-16 03:58:27.272
1b5c71d8-fab1-467f-9a40-b2dbe3e814d1	High Risk	2025-05-16 04:01:34.325	2025-05-16 04:01:34.325
25cdc5ef-87bc-4c0e-a17f-0b5a3a3dba21	Staff	2025-05-16 09:12:52.906	2025-05-16 09:12:52.906
5b22154d-fb85-4115-a8c9-5aac0c86ec4e	Manager	2025-05-16 09:12:58.309	2025-05-16 09:12:58.309
1bb53e2d-e0c2-470a-a135-c96794f21b73	Certificate	2025-05-16 09:13:10.724	2025-05-16 09:13:10.724
3d41db70-c193-4a6d-9a7e-8ebe4115919f	Advanced	2025-05-16 09:13:16.179	2025-05-16 09:13:16.179
435815a6-18cb-4b85-bab7-9609e1b3076e	Food Safety (Dubai)	2025-05-16 09:52:32.634	2025-05-16 09:52:32.634
bdf4eea5-e188-475b-993d-c3f8fd20bba9	Food Safety (Fujairah)	2025-05-16 09:52:46.853	2025-05-16 09:52:46.853
b3afefae-cbaa-4244-9691-0a69f358fabb	Pest Control	2025-06-16 07:52:25.362	2025-06-16 07:52:25.362
6b44ea7e-da9e-4884-9850-8b04ca24555b	Technician	2025-06-16 07:53:29.046	2025-06-16 07:53:29.046
d9e6c630-47c0-4048-9089-a7ad18a3f260	Supervisor	2025-06-16 07:53:40.63	2025-06-16 07:53:40.63
\.


--
-- Data for Name: Client; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Client" (id, name, phone, email, "createdAt", "updatedAt", "contactPersonName", "tradeLicenseNumber", "contactPersonPosition", landline) FROM stdin;
f8c20dd3-4cc8-4122-8f2c-de44d58d632b	Acme Corporation	+971501234567	info@acme1.com	2025-05-26 17:22:44.84	2025-05-26 17:22:44.84	John Doe	123456789	General Manager	042345678
3a9a8f6e-fa8c-47be-a1d3-53e01e222a0a	Global Tech	+971502345678	contact@globaltech1.com	2025-05-26 17:22:44.84	2025-05-26 17:22:44.84	Jane Smith	987654321	IT Director	043216789
afb4e1b2-76cb-4b63-96ea-41d8e1602221	dfad	971502345677	contact@globaltech1231.com	2025-05-26 17:22:44.84	2025-05-26 17:22:44.84	Jane Smith123	98765432123123	Sales	43216789455
4ad20377-f656-4d0d-9f2d-a9ce0beeb416	ATLAS hypermarket	581075922	abhiraminandakumar98@gmail.com	2025-06-10 08:13:36.028	2025-06-10 08:13:36.028	abhi	CN-1207589	abhi	
7c766643-b35b-479a-99e2-94878a9e227c	SHAJAY CAFE	507655799	rover.naguit04@gmail.com	2025-06-10 08:19:41.149	2025-06-10 08:19:41.149	Rover	CN-5468335	Rover	
4bd2ff98-b0ef-4ca2-92a5-64a0db6db121	Joe	0556575757	vishnujoe@gmail.com	2025-06-10 19:42:18.046	2025-06-10 19:42:18.046				
4df9683f-bcea-4a94-83e8-aa0104598df6	Joe123			2025-06-11 14:40:01.837	2025-06-11 14:40:01.837				
77336f30-ab36-4045-b732-472bc15e840a	Joe34535435			2025-06-11 15:07:59.096	2025-06-11 15:07:59.096				
5ac2c0c9-9da9-4da5-976c-7da2574f4ea5	Joe123			2025-06-11 15:26:04.382	2025-06-11 15:26:04.382				
bc8b9407-ed41-4c27-80a8-f7dfdc9006e4	Kitopi	0544398585	rtorres@kitopi.com	2025-06-12 08:45:08.52	2025-06-12 08:45:08.52	Rochelle M. Torres	CN-4428223	People Ops Coordinator II	04 350 2002 
bccf57b5-6d80-4d89-893a-823c5882d574	FASSCO Catering - Danat	02 614 9999 Ext-1215	admin.dae@fasscointernational.ae	2025-06-12 09:29:57.992	2025-06-12 09:29:57.992	Josephine Del Rosario	CN-1560322	Helpdesk Co-ordinator	0504191780
538a5e30-a780-4eea-938f-901b1241151e	foxy cafe	5123669696		2025-06-12 13:01:51.933	2025-06-12 13:01:51.933				
e9d0d0a5-d796-45ea-ac7c-bf3af333c9e7	FOXY CAFE			2025-06-14 07:44:17.177	2025-06-14 07:44:17.177		CN-1205861		
3682ce0b-4dd5-4b8d-8a16-2bd97747060f	Joe	0556575757	ahebwahadijah@gmail.com	2025-06-14 07:46:32.687	2025-06-14 07:46:32.687				
21f783e5-427a-4235-96b3-32e20b076b79	SHAJAY CAFE	5236915236		2025-06-14 07:48:07.88	2025-06-14 07:48:07.88		CN-1236589		
ed5d5ef8-eecc-4386-a138-6a93c5cdbf76	just burger			2025-06-14 07:48:37.986	2025-06-14 07:48:37.986		CN-1253689		
678879d2-39bb-47c1-b30c-d032f7135879	Just Silver grocery\t	 569564786		2025-06-14 11:17:54.615	2025-06-14 11:17:54.615				
36f9b6d7-ea7d-46ea-9659-c381caac36d8	Al Taleb Grocery \t	568480895		2025-06-14 11:18:23.064	2025-06-14 11:18:23.064				
dd8386fc-c771-4a1c-879d-56ebea61502b	Al Rahi Roastery	566038745		2025-06-14 11:22:54.578	2025-06-14 11:22:54.578				
784da859-17d8-408d-b989-418295c670a0	Al rahi Roastery	566038745		2025-06-14 11:23:12.82	2025-06-14 11:23:12.82				
c1037228-4711-47e7-b2d9-f819f79c9c35	Al Ajwa Baqala \t	544508990		2025-06-14 11:23:32.789	2025-06-14 11:23:32.789				
f3a7e9fd-14cf-417e-b016-10c3f9fc7a35	Just Silver grocery\t	 569564786		2025-06-14 11:24:21.601	2025-06-14 11:24:21.601				
adfe99c0-4aaf-4bc8-9751-401478797024	Al Taleb Grocery \t	568480895		2025-06-14 11:24:31.224	2025-06-14 11:24:31.224				
c8852652-369f-4d96-975a-849480a08b84	Al Rahi Roastery	566038745		2025-06-14 11:24:38.412	2025-06-14 11:24:38.412				
a36c7393-ab83-45f8-bf32-ac957cd7156e	Al rahi Roastery	566038745		2025-06-14 11:24:45.8	2025-06-14 11:24:45.8				
bb8454f3-7313-428f-8b72-9866f109bcbe	Al Ajwa Baqala \t	544508990		2025-06-14 11:24:57.185	2025-06-14 11:24:57.185				
decc0d74-794f-46dc-a3a7-b723f6412f26	Just Silver grocery\t	 569564786		2025-06-14 11:36:39.15	2025-06-14 11:36:39.15				
19acec89-1f0b-422f-bf24-e9ac9b97afb4	Al Taleb Grocery \t	568480895		2025-06-14 11:36:59.029	2025-06-14 11:36:59.029				
9483a9f1-5324-4c29-a3e7-0e8e482d05e6	Al rahi Roastery\t	566038745		2025-06-14 11:37:32.367	2025-06-14 11:37:32.367				
0b2dd9d1-8a63-4369-b3e3-296d3f88b755	Al Taleb Grocery \t	568480895		2025-06-14 11:38:03.953	2025-06-14 11:38:03.953				
42dd34bc-01e0-4d38-8bfd-7458275afb81	Al rahi Roastery\t	566038745		2025-06-14 11:38:13.201	2025-06-14 11:38:13.201				
193d3b2e-effa-4fef-ace3-009375824771	Al rahi Roastery\t	566038745		2025-06-14 11:38:19.061	2025-06-14 11:38:19.061				
3f898e27-c9fe-4cb1-a23c-7a921bfb3fc3	Al Azhaar Restaurant and Grilled\t	565908276		2025-06-14 11:39:04.058	2025-06-14 11:39:04.058				
bf8b4bfa-b5b9-406a-a695-bf24c5360e3f	The Healthy Plate Restaurant\t	509078011    		2025-06-14 11:39:31.951	2025-06-14 11:39:31.951				
8925fa5d-0a83-41db-84f8-0a6af62c2e6a	Al Rowdha restaurant\t	528493811		2025-06-14 11:39:54.333	2025-06-14 11:39:54.333				
a9f24310-d79f-49da-9e7f-9b896993ee1a	Al Rowdha restaurant\t	528493811		2025-06-14 11:40:13.391	2025-06-14 11:40:13.391				
284d9f2d-e3de-443c-8fd0-b1493435d826	Al Azhaar Restaurant and Grilled\t	565908276		2025-06-14 11:40:31.614	2025-06-14 11:40:31.614				
a87a039a-6c9d-416a-bf60-a7a4f7629e78	Crowds Restaurant\t	504042075		2025-06-14 11:41:10.458	2025-06-14 11:41:10.458				
20583da8-a374-474a-8c32-976e06fdd146	Madr Alsah Restaurant\t	509235289		2025-06-14 11:45:02.996	2025-06-14 11:45:02.996				
4220d446-604e-4710-b375-4155c3958f9e	Odore café \t	566578062		2025-06-14 11:45:22.5	2025-06-14 11:45:22.5				
621e8427-30db-4fec-80d8-2a527e66ac46	AlJeel cafeteria\t	 506736165		2025-06-14 11:45:43.161	2025-06-14 11:45:43.161				
10eecd82-6ed6-40b0-9483-ffe5d2a82c51	Jibal Albaraka Restaurant and Kitchen \t	523897747		2025-06-14 11:46:05.351	2025-06-14 11:46:05.351				
cd79415d-c655-4a15-830b-fe43ac31477d	Sofra Baniyas Restaurant\t	563523882		2025-06-14 11:46:52.504	2025-06-14 11:46:52.504				
c7e7b71a-4889-47de-b7cf-e7ab8df1d103	Eat and Drink Restaurant\t	 545319766		2025-06-14 11:47:54.27	2025-06-14 11:47:54.27				
4a03a781-4417-44d2-a403-af4edc9fdaca	Al rahi Roastery\t	566038745		2025-06-14 11:51:43.89	2025-06-14 11:51:43.89				
d870bbe4-630b-40fb-b736-962ade8f38af	Al Ajwa Baqala \t	544508990		2025-06-14 11:52:03.72	2025-06-14 11:52:03.72				
4109353d-a881-4023-8a8a-ab3c5ac6239c	Charminar Baqala\t	553581433		2025-06-14 11:52:34.15	2025-06-14 11:52:34.15				
28ad5daf-69d1-4210-9a54-85693064791b	Al Azhaar Restaurant and Grilled\t	565908276		2025-06-14 11:58:58.115	2025-06-14 11:58:58.115				
3eaf214c-43ea-453b-bdad-81239333e939	The Healthy Plate Restaurant\t	509078011    		2025-06-14 11:59:22.693	2025-06-14 11:59:22.693				
17f0fabb-7364-49cc-ae50-d61db1d7f467	Al Rowdha restaurant\t	528493811		2025-06-14 11:59:54.041	2025-06-14 11:59:54.041				
2d709440-9bf0-4fd6-bd68-504c07c7dfc6	Al Rowdha restaurant\t	528493811		2025-06-14 12:00:14.956	2025-06-14 12:00:14.956				
bea2bf94-4019-4117-beb6-d6ccc3555eb0	Al Azhaar Restaurant and Grilled	0565908276		2025-06-14 12:00:41.211	2025-06-14 12:00:41.211				
60f397e5-4248-4af4-9857-8693b6847d6f	Crowds Restaurant\t	504042075		2025-06-14 12:04:27.439	2025-06-14 12:04:27.439				
1385cc2f-6d3f-4d83-bbea-c091c548645c	Madr Alsah Restaurant\t	50 923 5289		2025-06-14 12:04:51.316	2025-06-14 12:04:51.316				
d6e6a0f3-5b3f-4aa5-9213-7b6e592e1080	Odore café \t	566578062		2025-06-14 12:05:14.863	2025-06-14 12:05:14.863				
a77cfb74-ac69-4cec-9186-57fc8e0cf732	AlJeel cafeteria\t	 50 673 6165		2025-06-14 12:05:40.79	2025-06-14 12:05:40.79				
a15f16d8-07f6-4297-b330-c6e41e593f39	Jibal Albaraka Restaurant and Kitchen \t	523897747		2025-06-14 12:06:04.923	2025-06-14 12:06:04.923				
9104b814-54ef-441c-8c34-11a6aac7d792	Sofra Baniyas Restaurant\t	3882		2025-06-14 12:50:26.701	2025-06-14 12:50:26.701				
2270d0b4-ea51-4085-ab88-f21966d87ffd	eat and Drink Restaurant\t	54 531 9766		2025-06-14 12:50:52.522	2025-06-14 12:50:52.522				
446a852c-c88f-4762-aac4-0d3d691cbe94	The Healthy Plate Restaurant\t	509078011    		2025-06-16 04:09:29.339	2025-06-16 04:09:29.339		CN-3861048		
78f0481a-faa9-452c-a299-7c4be83d5c60	The Healthy Plate Restaurant\t	509078011    		2025-06-16 04:11:50.073	2025-06-16 04:11:50.073		CN-3861048		
ba6a8c7d-0fd4-4c10-b540-31196b8b2240	The Healthy Plate Restaurant\t	509078011    		2025-06-16 04:12:46.338	2025-06-16 04:12:46.338		CN-3861048		
1f552161-e1f5-4f7e-a406-50ec89e913dc	The Healthy Plate Restaurant\t	509078011    		2025-06-16 04:16:45.552	2025-06-16 04:16:45.552		CN-3861048		
848f57fb-80db-451c-af69-644f03a2714f	Odore café \t	566578062		2025-06-16 04:18:13.092	2025-06-16 04:18:13.092				
4f5ccd16-cd57-4a9b-93aa-9f808bc4fd23	Odore café \t	566578062		2025-06-16 04:18:31.966	2025-06-16 04:18:31.966		CN-2972597		
dfa0aa01-0641-483f-a72d-e894fc45985a	Odore café \t	566578062		2025-06-16 04:20:53.354	2025-06-16 04:20:53.354		CN-2972597		
a66f8c40-e9d4-4551-8b52-3106ed396621	Just Silver grocery\t	 569564786		2025-06-16 04:23:24.798	2025-06-16 04:23:24.798		CN-1482339		
441087b7-81fd-4803-a282-28ed106e5238	Just Silver grocery\t	 569564786		2025-06-16 04:25:12.287	2025-06-16 04:25:12.287		CN-1482339		
0c7facc0-4889-4f06-bc65-78c179ca72cf	Al Ajwa Al Dhabia  Baqala \t	544508990		2025-06-16 04:29:25.298	2025-06-16 04:29:25.298		CN-3859508		
a0c0cd5c-1b0f-42a5-801e-2bfcca40c95f	Madr Alsah Restaurant\t	50 923 5289		2025-06-16 04:33:19.697	2025-06-16 04:33:19.697		CN-4910436		
6db40690-6627-46c4-8e63-88bf2ed0fb9e	Madr Alsah Restaurant\t	50 923 5289		2025-06-16 04:35:50.76	2025-06-16 04:35:50.76		CN-4910436		
2772b8a2-16d5-40df-8fb0-83355e2a3c9d	Alafdaliya General Trading 	566038745		2025-06-16 04:40:36.745	2025-06-16 04:40:36.745		CN-4544205		
d9147636-036d-4b32-a7af-6d555c3bd9c9	Al rahi Roastery\t	566038745		2025-06-16 04:43:22.747	2025-06-16 04:43:22.747				
9757fcf7-4b96-4cf6-9511-e4f37f7958b8	Mureijb Bakery\t			2025-06-16 04:48:00.012	2025-06-16 04:48:00.012		CN-1165014		
589fdd9a-9ad1-4ad6-a473-72c8895759eb	Al Azhaar Restaurant and Grilled	0565908276		2025-06-16 04:52:21.476	2025-06-16 04:52:21.476				
97854d7b-f2c8-4b3d-81a9-a05a6faeec56	AlJeel cafeteria\t	 506736165		2025-06-16 04:55:06.8	2025-06-16 04:55:06.8		CN-1111909		
da1b06a8-df21-4c4a-a6b7-7a4d9b136f93	Al Rowdha restaurant\t	528493811		2025-06-16 04:59:32.131	2025-06-16 04:59:32.131		CN-1111985		
8373bc54-8ea4-4e42-b04c-8d086b70e3f3	Al Rowdha restaurant\t	528493811		2025-06-16 05:01:31.949	2025-06-16 05:01:31.949		CN-1111985		
f2d597d3-c725-4e29-9839-f771cfbb7929	Al Taleb Grocery \t	568480895		2025-06-16 05:06:58.938	2025-06-16 05:06:58.938		CN-1114345		
448c2ee1-e9a1-4065-86f2-51f6ac42b967	eat and Drink Restaurant\t	54 531 9766		2025-06-16 05:11:09.581	2025-06-16 05:11:09.581		CN-2269058		
b413d808-20dc-4956-aab1-f6ad3778dcf7	Charminar Baqala\t	553581433		2025-06-16 05:15:56.9	2025-06-16 05:15:56.9		CN-4678816		
4634e3c5-641d-48ff-afd4-aa4ad91809a5	Al Azhaar Restaurant and Grilled\t	565908276		2025-06-16 05:21:50.008	2025-06-16 05:21:50.008				
d493efe3-e4bc-41a7-8f67-72b5340b992e	Jibal Albaraka Restaurant and Kitchen \t	523897747		2025-06-16 05:26:00.412	2025-06-16 05:26:00.412				
d5f6bd1e-5377-495a-9dc3-86dde961818b	Al Azhaar Restaurant and Grilled\t	565908276		2025-06-16 05:26:58.112	2025-06-16 05:26:58.112		CN-1114171		
462eda1e-0a8a-4159-9611-38fddbc5500a	Al Azhaar Restaurant and Grilled\t	565908276		2025-06-16 05:29:29.68	2025-06-16 05:29:29.68		CN-1114171		
d05d2af3-9a83-4240-863a-f3418ba8a6a0	Al Ehtifal Fruits & Vegetables\t			2025-06-16 05:30:24.321	2025-06-16 05:30:24.321		CN-2182631		
2e26c493-9371-403e-89df-9250ac88ae3b	Al Ehtifal Fruits & Vegetables\t			2025-06-16 05:31:54.223	2025-06-16 05:31:54.223		CN-2182631		
3e30a142-c5b8-4e03-abe2-cbbbd07b9c5a	Al Ehtifal Fruits & Vegetables\t			2025-06-16 05:34:29.16	2025-06-16 05:34:29.16		CN-2182631		
624363f0-305b-4060-9df6-9d4d927f4eb3	Al Ehtifal Fruits & Vegetables\t			2025-06-16 05:36:04.515	2025-06-16 05:36:04.515		CN-2182631		
3c50ed16-11f6-41d3-9a57-d85a2c3e06c0	Just Silver grocery\t	 569564786		2025-06-16 05:39:46.85	2025-06-16 05:39:46.85		CN-1482339		
3b42af53-aa96-43bc-87b1-130a0fd6cd73	Just Silver grocery\t	 569564786		2025-06-16 05:40:49.863	2025-06-16 05:40:49.863		CN-1482339		
77f91b77-08fe-4451-ac63-bf82e681e7bd	Al Taleb Grocery \t	568480895		2025-06-16 05:41:09.945	2025-06-16 05:41:09.945		CN-1114345		
2eaa3805-dd68-4128-8837-6660f05b13a0	Al rahi Roastery\t	566038745		2025-06-16 05:41:13.469	2025-06-16 05:41:13.469				
8653b5ce-4619-4dad-9cad-dfda7927d332	Alafdaliya General Trading 	566038745		2025-06-16 05:41:16.506	2025-06-16 05:41:16.506		CN-4544205		
e49f8a84-b1bd-4984-a605-a8d5a2462c25	Alafdaliya General Trading 	566038745		2025-06-16 05:41:19.265	2025-06-16 05:41:19.265		CN-4544205		
2ae3fe6e-dc12-4787-9c32-99ad563b4224	Al Ajwa Al Dhabia  Baqala \t	544508990		2025-06-16 05:41:22.659	2025-06-16 05:41:22.659		CN-3859508		
45444159-0667-4d1a-9a7d-eeb106ef9553	Charminar Baqala\t	553581433		2025-06-16 05:41:25.306	2025-06-16 05:41:25.306		CN-4678816		
1d2bbec7-6e86-4fc1-9bd0-4b190715d17d	Alafdaliya General Trading 	566038745		2025-06-16 05:44:32.334	2025-06-16 05:44:32.334		CN-4544205		
57155c14-16f6-407a-9e11-2c018e5e6b0c	Just Silver grocery\t	 569564786		2025-06-16 05:44:52.917	2025-06-16 05:44:52.917		CN-1482339		
3e61df5f-1fb5-4980-986e-e305676d5af8	Just Silver grocery\t	 569564786		2025-06-16 05:45:06.462	2025-06-16 05:45:06.462		CN-1482339		
66c8f02b-e4b0-44cb-87a7-1b8a34917c55	Al Azhaar Restaurant and Grilled\t	565908276		2025-06-16 05:57:17.709	2025-06-16 05:57:17.709		CN-1114171		
cbcd83b9-0e70-4e4f-acc5-b432fac89b9a	Al Rowdha restaurant\t	528493811		2025-06-16 05:57:20.681	2025-06-16 05:57:20.681		CN-1111985		
00ee119d-558d-406e-b6c0-1482449c78cf	Al Azhaar Restaurant and Grilled	0565908276		2025-06-16 05:58:20.509	2025-06-16 05:58:20.509				
718ba1f6-5304-4aa5-9bf4-84c5a7b3b2e9	Sforno Pizza and Pasta Restaurant	0565908276		2025-06-16 05:58:58.867	2025-06-16 05:58:58.867		CN-4687529		
b3a9dfe8-2dd7-4334-931c-74dd5a20486b	Crowds Restaurant\t	504042075		2025-06-16 05:59:42.766	2025-06-16 05:59:42.766				
a95cc7a6-b29e-471d-8fa9-fe0a1d99107d	Madr Alsah Restaurant\t	50 923 5289		2025-06-16 06:00:55.614	2025-06-16 06:00:55.614		CN-4910436		
99c0aa16-34cb-43f9-b8dd-c012ac4dd4a6	Sofra Baniyas Restaurant\t	 56 352 3882		2025-06-16 06:11:04.209	2025-06-16 06:11:04.209		CN-5130721		
4eb42f69-98fa-438b-9588-d4d8a5b344cc	Sofra Baniyas Restaurant\t	 56 352 3882		2025-06-16 06:12:21.31	2025-06-16 06:12:21.31		CN-5130721		
61eabe89-d77c-4cfe-9ce1-6a230d341def	Alafdaliya General Trading 	566038745		2025-06-16 07:28:12.471	2025-06-16 07:28:12.471		CN-4544205		
4092d932-d667-4192-b0be-a191e81a082f	Just Silver grocery\t	 569564786		2025-06-16 07:30:29.516	2025-06-16 07:30:29.516		CN-1482339		
3ee36362-4c95-4f20-bd3f-8a452f45f3f7	Foxy cafe 	0563523882		2025-06-16 10:38:07.645	2025-06-16 10:38:07.645		CN-1236589		
3f4b1c67-a606-4bdf-a9bf-6b6dd8c3b003	Foxy cafe 	0563523882		2025-06-16 10:39:44.737	2025-06-16 10:39:44.737		CN-1236589		
e07d400c-c719-41eb-aa48-83ba0610c0be	Foxy cafe 	0563523882		2025-06-16 10:45:38.998	2025-06-16 10:45:38.998		CN-1236589		
6d8adbba-f253-4d08-98c9-5d3107375cbf	Top Choice Baqala \t			2025-06-16 12:36:22.535	2025-06-16 12:36:22.535				
df7bcada-e79a-4cee-99d9-4584c2713ac0	Top Choice Baqala \t	566592424		2025-06-16 13:05:16.534	2025-06-16 13:05:16.534				
7224154e-4df8-4137-b1d5-bb4fb42d7a71	HDMS Fruits and  Vegetables	 505732969		2025-06-17 04:11:37.578	2025-06-17 04:11:37.578		CN-5664571		
a302d556-d7a7-481c-8350-929ed7847f8e	HDMS Fruits and Vegetables	 505732969		2025-06-17 04:15:39.714	2025-06-17 04:15:39.714		CN-5664571		
cd35114e-c679-41da-9dab-b3e9c6f080f3	HDMS Fruits and  Vegetables	 505732969		2025-06-17 04:16:56.796	2025-06-17 04:16:56.796		CN-5664571		
a6bb41ea-0713-4330-a517-69a2bca1d921	Al Sultan bakery and Supermarket 			2025-06-17 04:24:57.703	2025-06-17 04:24:57.703		CN-1111903		
6e6fac26-07e7-4087-a8bc-3079f8e92f21	Al Sultan bakery 			2025-06-17 04:27:41.904	2025-06-17 04:27:41.904		CN-CN-1111902		
b8b0c157-d08e-4d15-98e3-32b5b81b3612	Al Sultan bakery 			2025-06-17 04:31:58.262	2025-06-17 04:31:58.262		CN-1111902		
a697ceb4-c5d8-4078-a545-c11127f5b07f	Four 1 Advertising LLC			2025-06-17 04:37:39.877	2025-06-17 04:37:39.877				
72b19cfa-a1d5-4a48-b635-a57a8e10e65e	Four 1 Advertising LLC			2025-06-17 04:39:34.283	2025-06-17 04:39:34.283		708579		
039eb8b3-2047-4da9-903d-53b893af7ea8	Four 1 Advertising LLC			2025-06-17 04:39:59.277	2025-06-17 04:39:59.277		708579		
7618a8a7-4d1a-4aa9-85f7-a009274b7a00	Al Sultan bakery 			2025-06-17 04:41:38.789	2025-06-17 04:41:38.789		CN-1111902		
625eb1af-724d-44ec-b84d-83b8a8ca0fca	Bahrain Flour Mills Co. BSC	+97317729984	shahida.n@bfm.bh	2025-06-16 07:19:23.135	2025-06-17 04:49:32.145	Shahida Noor Ahammad Mahasooldar		Technical Services Manager	+973 17729984 - 222
e92b0346-3636-494d-9969-461ffa166f32	Four 1 Advertising LLC			2025-06-17 06:06:07.648	2025-06-17 06:06:07.648		708579		
fac37f30-e03f-4e8f-a8c3-26abbbcc3dff	Edition Hotel Abu Dhabi	0544497697	IanCzar.Bangcong@editionhotels.com	2025-06-17 06:54:23.816	2025-06-17 06:54:23.816	Ian Czar E. Bangcong		MULTI-PROPERTY OCCUPATIONAL SAFETY, HEALTH AND HYGIENE MANAGER	
60c68940-4e2c-4aa4-bb04-4d3a9aecc242	The Edition Hotel 			2025-06-17 06:55:09.274	2025-06-17 06:55:09.274				
30e3d0f2-d4e2-4a2e-a053-db23dcd666d1	The Edition Hotel 			2025-06-17 06:55:23.556	2025-06-17 06:55:23.556				
5dfb8dcf-fbd6-4805-857a-2df0655e1040	HDMS Fruits and Vegetables	 505732969		2025-06-17 08:15:54.921	2025-06-17 08:15:54.921		CN-5664571		
d02f8362-5097-4e5f-adb1-f0036a800004	Chaonene Market \t	561419016		2025-06-17 08:17:05.182	2025-06-17 08:17:05.182		CN-5706560		
41b7892a-7929-4f01-9403-372e03ee9d5a	Doltchi Flowers and Perfumes \t	504047046		2025-06-17 08:24:58.946	2025-06-17 08:24:58.946		CN-1133360		
1a00b771-50f2-446c-a528-8be1a62b35ae	Doltchi Flowers and Perfumes \t	504047046		2025-06-17 08:50:14.183	2025-06-17 08:50:14.183		CN-1133360		
7fcd08f9-daef-45d8-b9c7-8349f2f9fd84	Lorans Rose Flowers and Perfumes\t	50 404 7046		2025-06-17 09:27:01.42	2025-06-17 09:27:01.42		CN-55501202		
4254c6d0-39e1-4d87-a89a-d88257e13356	Growth Food stuff Trading \t	507637653		2025-06-17 09:28:33.717	2025-06-17 09:28:33.717		CN--4548280		
fbf4de8b-c098-4ccc-a564-35626df0fb16	Al Hor Camping and Hunding Tools\t	50 113 2930		2025-06-17 09:29:33.955	2025-06-17 09:29:33.955		CN-5354162		
9ecc3834-ac4a-4213-90d4-7167469e507c	Al Hor Camping and Hunding Tools\t	568521107		2025-06-17 09:30:23.888	2025-06-17 09:30:23.888				
0669a76b-cdfd-48ba-94ee-6bab32860c65	Al Hor Camping and Hunding Tools\t	568521107		2025-06-17 09:30:32.864	2025-06-17 09:30:32.864		CN-5354162		
db268d2d-12f0-45af-b9fd-3a25eba4373d	Chaonene Market \t	561419016		2025-06-17 09:32:06.756	2025-06-17 09:32:06.756		CN-5706560		
90f3ba09-d388-45ec-be57-4cb5b46897ad	HDMS Fruits and Vegetables	 505732969		2025-06-17 09:41:43.496	2025-06-17 09:41:43.496		CN-5664571		
20cd78be-6c86-4289-afcb-7ae90bdb3a6b	Al Sultan bakery and Supermarket 			2025-06-17 09:57:39.456	2025-06-17 09:57:39.456		CN-1111903		
fbac0c73-0cee-4d81-893b-717d17ac7635	Al Sultan bakery 			2025-06-17 10:09:11.118	2025-06-17 10:09:11.118		CN-1111902		
967301c6-04dc-4059-b87d-89558b332349	Top Choice Baqala \t	566592424		2025-06-18 04:40:00.154	2025-06-18 04:40:00.154				
65a53278-1e05-4700-a02d-d36331c78241	Dream Life General Trading 	504729622		2025-06-18 06:04:53.847	2025-06-18 06:04:53.847		CN-5488117		
9b7f9e45-2757-46d6-acb8-80de78b19c91	Dream Life General Trading 	504729622		2025-06-18 06:09:03.745	2025-06-18 06:09:03.745		CN-5488117		
9833cb1b-d5c7-4b84-a8eb-73a1ac72306a	Almarai Emirates Company LLC\t	562829603		2025-06-18 06:49:04.972	2025-06-18 06:49:04.972		CN-1408170		
d9e66f77-3c07-4512-ac8f-57592dd14ec7	Almarai Emirates Company LLC\t			2025-06-18 07:02:03.465	2025-06-18 07:02:03.465		CN-1408170		
011a3589-b6ad-4a36-9ab6-50c6b8b58982	Almarai Emirates Company LLC\t	562829603		2025-06-18 07:02:11.042	2025-06-18 07:02:11.042		CN-1408170		
945530b8-8f49-4941-8166-6200b288a221	Almarai Emirates Company LLC\t			2025-06-18 07:02:13.708	2025-06-18 07:02:13.708		CN-1408170		
25d94776-32c6-428a-8a6f-f1096f18e62f	Almarai Emirates Company LLC\t			2025-06-18 07:31:10.81	2025-06-18 07:31:10.81		CN-1408170		
f2e8805b-51b0-4159-a136-0c41d9deb957	Almarai Emirates Company LLC\t			2025-06-18 07:31:50.452	2025-06-18 07:31:50.452		CN-1408170		
71eed89e-8ac6-4886-85b9-0708d503b553	Family Grocery \t	551644200		2025-06-18 07:32:45.171	2025-06-18 07:32:45.171		CN-1134374		
f9a05d4b-703c-4119-b757-c2adb61a76aa	Abdulla Al banna Meat products-Self\t			2025-06-18 07:33:11.22	2025-06-18 07:33:11.22				
3d855b26-6e2f-47cd-a048-fca8ab1dc117	Noor Al Anka Grocery \t	556141523		2025-06-18 07:34:31.4	2025-06-18 07:34:31.4		CN-1112972		
3fa141e5-58e2-4881-95ff-b2926503ff38	Noor Al Anka Grocery \t			2025-06-18 07:35:11.19	2025-06-18 07:35:11.19		CN-1112972		
1f9b1591-ac2e-47f9-b27b-de753e670172	Al Hamwi Global General Trading \t			2025-06-18 07:35:49.544	2025-06-18 07:35:49.544		CN-2637915		
556e1630-d4bb-4572-8459-27c35f8e02ca	MSH Baqala \t	52 538 9377		2025-06-18 07:36:41.713	2025-06-18 07:36:41.713		CN-4834683		
31596562-0f4c-4a47-813d-03b4756e7426	Al Hor Camping and Hunding Tools\t	50 113 2930		2025-06-18 07:37:36.673	2025-06-18 07:37:36.673		CN-5354162		
ddddf271-6ed6-4060-b5da-9c1274e91435	Al Hor Camping and Hunding Tools\t	50 113 2930		2025-06-18 07:38:29.658	2025-06-18 07:38:29.658		CN-5354162		
9731818d-0a37-4c08-b1c2-105c87eb2975	Zahrat Abu Samra Grocery\t	58 577 9336		2025-06-18 07:40:28.725	2025-06-18 07:40:28.725		CN-1110185		
b95834a2-688a-4ada-bea5-6d60908df3a4	Regullar Baqala\t			2025-06-18 07:41:38.495	2025-06-18 07:41:38.495		CN-2941771		
1dc7b1b8-133b-41ba-ae23-dbe6210774cf	Almarai Emirates Company LLC\t	562829603		2025-06-18 07:43:40.307	2025-06-18 07:43:40.307		CN-1408170		
06ae6ed6-4b3f-463d-93ca-7a1f1d8ec599	Almarai Emirates Company LLC\t			2025-06-18 07:43:54.54	2025-06-18 07:43:54.54		CN-1408170		
f8df967d-fe11-49fb-a9f1-587a0e232913	Almarai Emirates Company LLC\t			2025-06-18 07:44:05.797	2025-06-18 07:44:05.797		CN-1408170		
0c4456ad-2656-4152-b57b-89b15fa01dec	Abdulla Al banna Meat products-Self\t			2025-06-18 07:44:22.232	2025-06-18 07:44:22.232				
65b995d3-06fc-42ec-9d8e-371906f1b337	Abdulla Al banna Meat products-Self\t			2025-06-18 07:44:37.316	2025-06-18 07:44:37.316		968910		
00ce70af-3b62-4e3c-bc34-2fcebd43bfc2	Abdulla Al banna Meat products-Self\t			2025-06-18 07:44:44.307	2025-06-18 07:44:44.307		968910		
890d69de-687b-42ac-85b9-5b846abcdbf9	Family Grocery \t	551644200		2025-06-18 07:44:49.38	2025-06-18 07:44:49.38		CN-1134374		
bad18cf1-aa20-4e13-88e0-42b79727d42d	Regullar Baqala\t			2025-06-18 07:47:13.584	2025-06-18 07:47:13.584		CN-2941771		
60d8a4c0-01f7-4343-9bed-22ea2770f199	Almarai Emirates Company LLC\t	562829603		2025-06-18 07:49:21.259	2025-06-18 07:49:21.259		CN-1408170		
5f61bbdd-3efb-436a-b4e4-b70040800df4	Almarai Emirates Company LLC\t	562829603		2025-06-18 07:49:30.353	2025-06-18 07:49:30.353		CN-1408170		
7bda9bea-3372-4291-b52d-a1f47a1a958d	Top Choice Baqala \t	566592424		2025-06-18 08:03:35.879	2025-06-18 08:03:35.879		CN-3837255		
20f80f02-f214-4bd2-96ce-dcfb057d098f	Dream Life General Trading\t	504729622		2025-06-18 08:04:06.183	2025-06-18 08:04:06.183		CN-5488117		
fe1b6619-28e7-47bb-bd14-aa42ac524891	Special Touch Meat and Fish Trading\t	568477499		2025-06-18 08:04:43.055	2025-06-18 08:04:43.055		CN-5605760		
cf9e29a9-4d28-43f1-b919-8fe5749ff6ee	Top Choice Baqala \t	566592424		2025-06-18 08:04:50.969	2025-06-18 08:04:50.969		CN-3837255		
05fd7606-9576-4903-b23d-7afc6ffce85f	Dream Life General Trading\t	504729622		2025-06-18 08:04:54.347	2025-06-18 08:04:54.347		CN-5488117		
17cc22bd-ff69-450b-a53a-7a62aca77444	Special Touch Meat and Fish Trading\t	568477499		2025-06-18 08:04:57.704	2025-06-18 08:04:57.704		CN-5605760		
5eb363cc-0f32-4bb7-bc7c-9210853e82a3	Al Mallah Restaurant & Grills\t	557135252		2025-06-18 08:05:34.548	2025-06-18 08:05:34.548		CN-1113909		
7a24802a-ef0b-4194-b32e-6e04084bbfa6	Almarai Emirates Company LLC\t	562829603		2025-06-18 08:18:43.223	2025-06-18 08:18:43.223		CN-1408170		
3fba4ad5-a3aa-4dd6-9f48-0cd87de7d518	Al Anqaa Grocery Shop \t	50 569 2486		2025-06-18 08:19:44.028	2025-06-18 08:19:44.028		CN-1120915		
8937d03a-7a2e-4e7b-8276-1a068906e29c	Special Touch Meat and Fish Trading\t	568477499		2025-06-18 08:44:57.327	2025-06-18 08:44:57.327		CN-5605760		
5ad0317d-0154-4fec-a40a-03051199ce1a	Dream Life General Trading\t	504729622		2025-06-18 08:45:01.771	2025-06-18 08:45:01.771		CN-5488117		
06377170-5e02-4ba4-b477-9952ead3ee04	Top Choice Baqala \t	566592424		2025-06-18 08:45:05.754	2025-06-18 08:45:05.754		CN-3837255		
b3ddd04b-b6c7-4187-bee2-69acf870c0fd	Al Mallah Restaurant & Grills\t	557135252		2025-06-18 08:45:15.799	2025-06-18 08:45:15.799		CN-1113909		
8c569af8-1e7b-4c81-9f23-357f74c2fed5	Al Anqaa Grocery Shop \t	50 569 2486		2025-06-18 08:45:32.469	2025-06-18 08:45:32.469		CN-1120915		
61082bca-9f33-4f7d-93c0-b871e577ced5	Almarai Emirates Company LLC\t			2025-06-18 09:06:43.553	2025-06-18 09:06:43.553		CN-1408170		
89b56cbc-c457-4bd6-a77d-83ae0223cdd9	Almarai Emirates Company LLC\t			2025-06-18 09:06:49.697	2025-06-18 09:06:49.697		CN-1408170		
61c58932-d4ff-4fa0-a3e9-be2ff7ff8b5d	Abdulla Al banna Meat products-Self\t			2025-06-18 09:06:53.968	2025-06-18 09:06:53.968		968910		
244cc615-ac4b-402e-aff3-047865258956	Family Grocery \t	551644200		2025-06-18 09:06:57.705	2025-06-18 09:06:57.705		CN-1134374		
120dc39a-6565-43d1-855d-88c7d3ba9448	Noor Al Anka Grocery \t	556141523		2025-06-18 09:07:05.868	2025-06-18 09:07:05.868		CN-1112972		
154db7a4-e280-4be7-aff4-2f6fc7ea2d06	Noor Al Anka Grocery \t			2025-06-18 09:07:09.753	2025-06-18 09:07:09.753		CN-1112972		
a0cbcab5-7f54-411e-91f3-d7215aea3649	Al Hamwi Global General Trading \t			2025-06-18 09:07:13.29	2025-06-18 09:07:13.29		CN-2637915		
102d69f2-6197-4e96-8a6e-0b49b2ec68d3	MSH Baqala \t	52 538 9377		2025-06-18 09:07:23.75	2025-06-18 09:07:23.75		CN-4834683		
2e3fe1ee-ab9d-438a-8e8b-c5966148b31a	Al Hor Camping and Hunding Tools\t	50 113 2930		2025-06-18 09:07:28.161	2025-06-18 09:07:28.161		CN-5354162		
3e812f04-3617-4dba-81de-16f259517260	Al Hor Camping and Hunding Tools\t	50 113 2930		2025-06-18 09:07:31.9	2025-06-18 09:07:31.9		CN-5354162		
7798d514-509c-45f0-84b3-3b13f1dfe4d0	Zahrat Abu Samra Grocery\t	58 577 9336		2025-06-18 09:07:35.93	2025-06-18 09:07:35.93		CN-1110185		
520c2e5c-1658-4ac8-8b16-8d8b71dd1d0f	Regullar Baqala\t			2025-06-18 09:07:39.447	2025-06-18 09:07:39.447		CN-2941771		
93936045-d9d1-4345-b225-5b5f351f065f	Burger Stop Cafeteria\t	50 233 3157		2025-06-18 09:09:35.347	2025-06-18 09:09:35.347		CN-2174527		
eb5153cd-fc2a-4281-ab46-3e49ea0d4a58	Burger Stop Cafeteria\t	50 233 3157		2025-06-18 09:09:44.569	2025-06-18 09:09:44.569		CN-2174527		
3e1e3b78-005c-4162-adaf-7c1eb2062692	Burger Stop Cafeteria\t	50 233 3157		2025-06-18 09:10:17.1	2025-06-18 09:10:17.1		CN-2174527		
5071d1ca-c087-4a31-a945-7aa9c54b95b4	Burger Stop Cafeteria\t	50 233 3157		2025-06-18 09:10:24.828	2025-06-18 09:10:24.828		CN-2174527		
c3a053ab-20cd-405c-bc84-4ed7b8a119c4	Zal Al Catering Services	 50 847 1618		2025-06-18 09:11:07.996	2025-06-18 09:11:07.996				
e0eeff21-332f-4410-b82b-a6cc58737141	Zad A; 			2025-06-18 09:11:19.551	2025-06-18 09:11:19.551				
5d54eccb-09d5-466f-890c-dc34d4082a17	Kunafeh House\t\t	 50 847 1618		2025-06-18 09:12:17.515	2025-06-18 09:12:17.515		CN-4751997		
5fe60526-29ea-446b-9fe5-9b792f8fae3f	Kunafeh House\t\t	 50 847 1618		2025-06-18 09:12:24.103	2025-06-18 09:12:24.103		CN-4751997		
15bea829-4f12-4d12-8a13-4c0083a4292c	Kunafeh House\t\t	 50 847 1618		2025-06-18 09:12:28.04	2025-06-18 09:12:28.04		CN-4751997		
f6f83b5d-024f-43c5-a9a8-da11fbd3a987	Kunafeh House\t\t	 50 847 1618		2025-06-18 09:12:42.519	2025-06-18 09:12:42.519		CN-4751997		
b685e3bb-c883-4c6a-a5b8-77021a74649b	Kunafeh House\t\t	 50 847 1618		2025-06-18 09:12:50.453	2025-06-18 09:12:50.453		CN-4751997		
2671a70e-5c71-4670-8167-ed53608874f1	Chick Choice Plus Restaurant 			2025-06-18 09:18:14.665	2025-06-18 09:18:14.665		CN-4262073		
5720cb33-bd94-4ee3-9a86-7d327bb0d443	Noor Al Anka Grocery \t	556141523		2025-06-18 09:25:27.687	2025-06-18 09:25:27.687		CN-1112972		
5b42b5fd-9890-481a-8ccb-bc85019596d5	Almarai Emirates Company LLC\t	562829603		2025-06-18 09:27:02.318	2025-06-18 09:27:02.318		CN-1408170		
1e48d1f3-a433-4b01-9dce-b38c66c47458	Almarai Emirates Company LLC\t	562829603		2025-06-18 09:27:08.129	2025-06-18 09:27:08.129		CN-1408170		
36bbde4c-b54f-475c-9a81-c7e51b056c40	Chick Choice Plus Restaurant 			2025-06-18 09:27:16.027	2025-06-18 09:27:16.027				
9243ebde-eb27-471e-bec9-261fdddba3e0	Almarai Emirates Company LLC\t	562829603		2025-06-18 09:28:28.003	2025-06-18 09:28:28.003		CN-1408170		
e6a94242-8b32-4732-bfc5-3211df76d75e	Abdulla Al banna Meat products-Self\t			2025-06-18 09:30:29.134	2025-06-18 09:30:29.134		968910		
44e1fd9e-260d-40ab-b167-cc96e73190d5	McDonalds			2025-06-18 09:31:33.447	2025-06-18 09:31:33.447	Mr. del			
8d654108-bf11-42e7-9f04-3f7fd24361bd	McDonalds			2025-06-18 09:32:23.312	2025-06-18 09:32:23.312	Mr. del			
3a5a787c-57d1-4354-b9bf-31ad0d8192d5	Dream Life General Trading\t	504729622		2025-06-18 09:36:14.117	2025-06-18 09:36:14.117		CN-5488117		
47239828-fe95-4d46-87c2-6088c980d882	Top Choice Baqala \t	566592424		2025-06-18 09:36:17.052	2025-06-18 09:36:17.052		CN-3837255		
4454c25d-e99d-41d6-b4f0-bf47778543a0	Dream Life General Trading\t	504729622		2025-06-18 09:36:25.061	2025-06-18 09:36:25.061		CN-5488117		
0bbb2130-a942-4880-ab39-ebcdd8a8a1f4	Kunafeh House\t\t	 50 847 1618		2025-06-18 09:36:40.289	2025-06-18 09:36:40.289		CN-4751997		
35e9c90e-7dec-41e2-9c18-c03beb4fb5f3	Kunafeh House\t\t	 50 847 1618		2025-06-18 09:36:44.762	2025-06-18 09:36:44.762		CN-4751997		
0dbd8427-c0ae-4d8c-85ce-84ea5c293c0f	Kunafeh House\t\t	 50 847 1618		2025-06-18 09:36:47.684	2025-06-18 09:36:47.684		CN-4751997		
b850ec0d-42bd-4344-ad5f-6148d61d2118	McDonalds			2025-06-19 08:21:14.151	2025-06-19 08:21:14.151	Mr. del			
eaca72ef-3b38-4dde-83e3-f6ef93c14faa	Wahat Algaia Restaurant 	502004572		2025-06-19 08:49:08.124	2025-06-19 08:49:08.124		CN-4253239		
047537e3-0a97-4d85-a913-d4969f48f1c6	Wahat Algaia Restaurant 	502004572		2025-06-19 08:49:16.14	2025-06-19 08:49:16.14		CN-4253239		
50ea441c-f5d4-499e-8311-a9fc78fcd6c9	Wahat Algaia Restaurant 	502004572		2025-06-19 09:14:00.959	2025-06-19 09:14:00.959		CN-4253239		
6a71df4d-86dd-4227-9a91-37dde4b899ae	RMK			2025-06-19 09:32:56.773	2025-06-19 09:32:56.773				
67eece4f-8323-4fee-930c-c0e4e8a455f6	RMK			2025-06-19 09:33:27.183	2025-06-19 09:33:27.183				
e23d8618-437c-4a6a-b57f-85c6d642abec	Air Fresh  Baqala 		kcgafoor4@gmail.com	2025-06-19 09:36:36.761	2025-06-19 09:36:36.761		CN-2715104		
3706599f-368b-4e7b-94f1-3ab2863394ee	Bin Salem Grocery			2025-06-19 09:38:05.714	2025-06-19 09:38:05.714		CN-1034963		
e0984f99-6261-4c7a-99f2-2a8aa92e6003	Akl Zaman Restaurant & Cafeteria 			2025-06-19 09:49:22.885	2025-06-19 09:49:22.885		CN-2168320		
096c1b31-fa30-423b-84e3-08e5821ecd50	jkk			2025-06-19 12:17:30.861	2025-06-19 12:17:30.861				
e6290065-84a8-41a2-a4ee-afdcf4406ad8	foxy cafe			2025-06-19 12:18:12.009	2025-06-19 12:18:12.009				
739879b1-9b64-4600-8c5c-72d6353bbf00	foxy cafe			2025-06-19 12:18:53.406	2025-06-19 12:18:53.406				
31352de1-ede2-4899-b78e-f5b1c0686752	RMK			2025-06-19 12:33:49.525	2025-06-19 12:33:49.525				
115d2c69-0404-4ea9-81d1-3793f79944ea	RMK			2025-06-19 12:36:13.435	2025-06-19 12:36:13.435				
5f2d859e-28ce-4e2f-a0eb-55a72ae9835c	Al Ajwa Al Dhabia  Baqala \t	544508990		2025-06-19 13:17:13.856	2025-06-19 13:17:13.856		CN-3859508		
d1763292-d79c-4f63-8780-af49962977f6	Al Ajwa Al Dhabia  Baqala \t	544508990		2025-06-19 13:18:08.65	2025-06-19 13:18:08.65		CN-3859508		
4f2d5aa9-d220-4c89-8e20-4ab2960b9e44	Al Ajwa Al Dhabia  Baqala \t	544508990		2025-06-19 13:18:22.923	2025-06-19 13:18:22.923		CN-3859508		
180f1ce7-2053-4e2d-a525-7729aa39062b	Al Ajwa Al Dhabia  Baqala \t	544508990		2025-06-19 13:21:16.48	2025-06-19 13:21:16.48		CN-3859508		
18dda4d6-bc2d-4204-bee4-3bef2d62acd0	lama			2025-06-20 05:56:41.849	2025-06-20 05:56:41.849		CN-2182631		
bcb088c3-0f6a-4e28-b71d-db3973462f3b	Rebel Foods/ Khalidya 			2025-06-20 06:00:19.506	2025-06-20 06:00:19.506		CN-1052215		
e98560ba-76b0-4ff6-b398-c08daeaf446c	lama			2025-06-20 06:00:55.666	2025-06-20 06:00:55.666		CN-2182631		
d4cd5e36-c7c7-45a4-904a-60347c7f7468	lama			2025-06-20 06:00:59.451	2025-06-20 06:00:59.451		CN-2182631		
c3f7a7fc-c335-411b-9c87-e483bffad355	lama			2025-06-20 06:01:06.624	2025-06-20 06:01:06.624		CN-2182631		
df60c47c-ffe3-4ba6-976e-a146b87541a4	lama			2025-06-20 06:01:10.766	2025-06-20 06:01:10.766		CN-2182631		
70bbeeb1-a750-4570-ad33-b78d2ad7f105	Rebel Foods/ Khalidya 			2025-06-20 06:01:51.795	2025-06-20 06:01:51.795		CN-1052215		
c89fd6d0-3c1c-4c02-92d8-e145cc69eace	Monaco Stars and Bars 			2025-06-20 06:04:31.793	2025-06-20 06:04:31.793		CN-2242162		
baa4f27a-4f02-4884-bf60-99b190b26d54	Monaco Stars and Bars 			2025-06-20 06:05:42.841	2025-06-20 06:05:42.841		CN-2242162		
5eaaa0b2-be62-4baa-a4a1-261b88f77978	Dar Karak & Muhala Restaurant 			2025-06-20 06:06:59.628	2025-06-20 06:06:59.628		CN-1048363		
4eb4f77d-8a1d-4789-891a-71b645b7ee31	Dar Karak & Muhala Restaurant 			2025-06-20 06:08:14.422	2025-06-20 06:08:14.422		CN-1048363		
d84a6807-b70e-45c8-8c15-c586c7cb08f8	Rebel Foods/ Khalidya 			2025-06-20 06:08:54.13	2025-06-20 06:08:54.13		CN-1052215		
91729021-cd82-400e-b38b-b387d6044c2c	Crownies Tahini and Sweets\t			2025-06-20 07:03:11.682	2025-06-20 07:03:11.682		IN-2006905		
769466b5-621c-435e-a32a-de71550e041b	Crownies Tahini and Sweets\t	508069918    		2025-06-20 07:04:37.355	2025-06-20 07:04:37.355		IN-2006905		
bb3c5e8f-da02-41c7-be11-7beaea08ff7e	Crownies Tahini and Sweets\t			2025-06-20 07:04:44.937	2025-06-20 07:04:44.937		IN-2006905		
b5dd9687-2f54-47ec-b590-55b8f737de30	Crownies Tahini and Sweets\t	508069918    		2025-06-20 07:04:51.866	2025-06-20 07:04:51.866		IN-2006905		
70831135-c1a8-44ed-ae8e-0610da62d5c6	Tierra Café \t			2025-06-20 07:15:06.154	2025-06-20 07:15:06.154		CN-4409924		
03d0bfdf-1cc7-4a4d-805c-a4c555f080fd	Tierra Café \t			2025-06-20 07:24:43.749	2025-06-20 07:24:43.749		CN-4409924		
d2bf71c0-16e8-4cf8-9915-5b7772f30229	Tierra Café \t			2025-06-20 07:24:48.664	2025-06-20 07:24:48.664		CN-4409924		
99429480-3b3f-4df3-98fc-0161833f547e	Tierra Café \t			2025-06-20 07:29:18.882	2025-06-20 07:29:18.882		CN-4409924		
84cc3a6a-2a58-4b85-a078-1e4bd7329b14	Tierra Café \t			2025-06-20 07:29:22.894	2025-06-20 07:29:22.894		CN-4409924		
cc8f564b-0f24-4550-9f86-3f08f8a5db33	,			2025-06-20 07:33:28.568	2025-06-20 07:33:28.568				
7be63d9c-a33d-41be-a937-f5aed9c5c77e	Tierra Café \t			2025-06-20 07:34:32.3	2025-06-20 07:34:32.3		CN-4409924		
2af2e84c-0cab-4794-95fc-bf4e807dd377	Tierra Café \t			2025-06-20 07:34:54.257	2025-06-20 07:34:54.257		CN-4409924		
1052d97d-523f-4810-9e8a-5869b7c5efea	Tierra Café \t			2025-06-20 07:35:02.235	2025-06-20 07:35:02.235		CN-4409924		
c04783f2-6792-4125-8701-ad230438c00d	Tierra Café \t			2025-06-20 07:36:33.221	2025-06-20 07:36:33.221		CN-4409924		
f57f0da2-0591-41ac-8efd-51da4ae7f133	Tierra Café \t			2025-06-20 07:36:37.519	2025-06-20 07:36:37.519		CN-4409924		
3b52ae1b-18f8-4249-8a16-ced34fc2177d	Tierra Café \t			2025-06-20 07:38:55.826	2025-06-20 07:38:55.826		CN-4409924		
a8ccd446-0f4b-4978-b992-a8078d25037b	United private school\t			2025-06-20 07:40:39.398	2025-06-20 07:40:39.398		CN-1191222		
badffac7-ef86-4940-b132-3f4a5bd7d68c	United private school\t			2025-06-20 07:41:06.519	2025-06-20 07:41:06.519		CN-4409924		
dddc09c2-4a5e-4932-a069-954b2580cb0e	United private school\t			2025-06-20 07:41:30.019	2025-06-20 07:41:30.019		CN-4409924		
b7533864-9712-4336-b28f-29467fe2095b	Tierra Café \t			2025-06-20 07:44:59.942	2025-06-20 07:44:59.942		CN-4409924		
616c1f39-5ecc-4ad6-9ad1-beab74030802	Four Points By Sheraton ,Al ain\t	Siby		2025-06-20 07:46:28.247	2025-06-20 07:46:28.247		CN-2239516		
d9b3f375-4d06-4233-ab84-dbd339a2f74f	Four Points By Sheraton ,Al ain\t	Siby		2025-06-20 07:47:35.643	2025-06-20 07:47:35.643		CN-2239516		
920fb5d9-127f-4194-955f-cb550c0162c1	Four Points By Sheraton ,Al ain\t			2025-06-20 07:49:06.069	2025-06-20 07:49:06.069		CN-2239516		
f1b452ae-83f1-4e33-b223-dc53fd0b2195	Four Points By Sheraton ,Al ain\t			2025-06-20 07:49:12.813	2025-06-20 07:49:12.813		CN-2239516		
9169b643-c961-4d6a-bb10-e321e5f7f895	Refill Reserve Cafe			2025-06-20 07:52:45.482	2025-06-20 07:52:45.482		CN-5275831		
073a3b7e-f658-4ec9-bb73-fe6ab6089c11	Zad Al Khair Catering \t			2025-06-20 07:55:14.371	2025-06-20 07:55:14.371		CN-2837838		
3324d174-d72f-4c10-8fd2-b3f6c40cefe4	Zad Al Khair Catering \t			2025-06-20 07:59:46.605	2025-06-20 07:59:46.605		CN-2837838		
5f58adea-e013-4cb8-8896-ea8cd2d9e9aa	Mang Philip Restaurant\t			2025-06-20 08:05:12.23	2025-06-20 08:05:12.23		CN-3881788		
27cd0dd2-56a1-4a46-b1e9-6560d000328e	Tierra Café \t			2025-06-20 08:08:28.167	2025-06-20 08:08:28.167		CN-4409924		
1ae050fc-4ed2-4a95-9b8f-19fe003d4f9e	Trio Cafe	542798894		2025-06-20 08:32:43.127	2025-06-20 08:32:43.127		CN-5122702		
a50a09d5-64c4-4f73-9c94-1edd95790504	Trio Cafe	542798894		2025-06-20 08:32:46.728	2025-06-20 08:32:46.728		CN-5122702		
31ea3b89-d249-4785-a510-c0184ddd205c	Trio Cafe	542798894		2025-06-20 08:32:52.174	2025-06-20 08:32:52.174		CN-5122702		
fa000dd1-5bea-4b78-88d2-58c13e89cc55	Trio Cafe	542798894		2025-06-20 08:32:55.584	2025-06-20 08:32:55.584		CN-5122702		
dbe74c44-b97b-478a-9ef5-6175b2119f76	Trio Cafe	542798894		2025-06-20 08:34:49.626	2025-06-20 08:34:49.626		CN-5122702		
db3c0fc1-14b3-43a9-ae66-2a8e9e866981	Trio Cafe 	542798894		2025-06-20 08:36:05.504	2025-06-20 08:36:05.504		CN-5122702		
bf31ae29-d1d1-464c-960c-7b2b4f7aac9b	Piece of Café\t	 569238807		2025-06-20 08:38:03.394	2025-06-20 08:38:03.394		CN-4601105		
73b3c68b-bc25-47df-9018-6339053339da	Piece of Café\t	0569238807		2025-06-20 08:38:24.686	2025-06-20 08:38:24.686		CN-4601105		
6d40fa2b-c1fe-4fb0-b843-cc5d44eaf119	Piece of Café\t	0569238807		2025-06-20 08:38:44.738	2025-06-20 08:38:44.738		CN-4601105		
75ba925f-cc77-47f1-b72a-75058652bd91	Feather Café \t	54 776 9038		2025-06-20 08:40:48.842	2025-06-20 08:40:48.842		CN-3991510		
47ee4e3c-fcdd-43f7-8eca-8ce377e97c05	Feather Café \t	0547769038		2025-06-20 08:41:16.486	2025-06-20 08:41:16.486		CN-3991510		
e71a8865-895b-4b06-b909-16602923ae2a	Feather Café \t	0547769038		2025-06-20 08:41:21.177	2025-06-20 08:41:21.177		CN-3991510		
f82dc0e7-d67d-4e1c-8e4a-f79f6ecea50a	BA and NS	2249		2025-06-20 08:42:05.646	2025-06-20 08:42:05.646				
b0cc0d03-ab50-4dae-b199-42c93c71ff25	b an ns			2025-06-20 08:42:17.464	2025-06-20 08:42:17.464				
5db1c617-fcba-4636-90a6-0ed82fa05991	best byte			2025-06-20 08:42:36.02	2025-06-20 08:42:36.02				
d8e33c9b-0aba-4f55-bed9-db617d1dd83a	rich bun cafe			2025-06-20 08:42:52.977	2025-06-20 08:42:52.977				
07dc7583-914e-4194-83bd-510e7feb9f1a	rich bun cafe			2025-06-20 08:43:01.658	2025-06-20 08:43:01.658				
50b59152-cdad-4ab1-9aee-67a40a43783b	rich bun cafe			2025-06-20 08:43:13.355	2025-06-20 08:43:13.355				
01ebe5cb-9648-4b7b-84b2-16496dae139a	Flamingo Events	56 521 2249		2025-06-20 09:04:31.731	2025-06-20 09:04:31.731		CN-2187100		
ead28f29-4972-4af3-834f-a8f2e421f527	Flamingo Events	56 521 2249		2025-06-20 09:04:36.31	2025-06-20 09:04:36.31		CN-2187100		
20c13fba-8437-4ba6-b474-b3c222796fb8	Flamingo Events	0565212249		2025-06-20 09:05:00.574	2025-06-20 09:05:00.574		CN-2187100		
a02f5f1d-377e-4eba-9f68-dc8791cc2260	BesByte African Restaurant	 52 483 0568		2025-06-20 09:06:35.35	2025-06-20 09:06:35.35		\t\tCN-3983803		
068e2d26-e9ab-494e-b226-94ce2fe51f5f	Margin cafe 	50 690 5404		2025-06-20 09:08:17.498	2025-06-20 09:08:17.498		CN-4316115		
5f071850-b347-4555-80d0-63e380feef37	Piece of Café\t	 569238807		2025-06-20 09:09:12.947	2025-06-20 09:09:12.947		CN-4601105		
ac16f4d9-eaec-4509-9193-3b5fcaa932e7	Margin cafe 	50 690 5404		2025-06-20 09:09:26.878	2025-06-20 09:09:26.878		CN-4316115		
4d969a9f-391b-402a-bbed-8624e7bbf8f0	Margin Café\t	50 690 5404		2025-06-20 09:09:56.76	2025-06-20 09:09:56.76		CN-4316115		
e63fd692-2249-4a25-9fd9-be1c9e8a1ac2	Margin Café\t	50 690 5404		2025-06-20 09:10:05.256	2025-06-20 09:10:05.256		CN-4316115		
09812af8-385b-4bcc-954c-1348c1ced959	Margin Café	0506905404		2025-06-20 09:10:30.414	2025-06-20 09:10:30.414		CN-4316115		
46387718-73e7-4ce2-b374-b44255442a63	Crownies Tahini and Sweets\t			2025-06-20 10:09:19.344	2025-06-20 10:09:19.344		IN-2006905		
e1913e79-8d9c-4aba-963c-8d7d7d475435	Four Points By Sheraton ,Al ain\t			2025-06-20 10:45:15.124	2025-06-20 10:45:15.124		CN-2239516		
ef65c43c-7a4a-4d00-a503-aecefcf5567f	Al Ramla Alfadhya Restaurant\t			2025-06-20 10:48:16.229	2025-06-20 10:48:16.229		CN-2574833		
26ef7b00-b718-4f01-8f68-2445cb4c21b5	Al Ramla Alfadhya Restaurant\t			2025-06-20 10:52:05.755	2025-06-20 10:52:05.755		CN-2574833		
146fe2ac-549d-42ce-aadc-89b9af3b29f0	Zad Al Khair Catering \t			2025-06-20 10:54:13.578	2025-06-20 10:54:13.578		CN-2837838		
fbab76b7-46c6-4d9c-ae49-4ccaaf153002	Zad Al Khair Catering \t			2025-06-20 10:54:35.962	2025-06-20 10:54:35.962		CN-2574833		
062e0ad6-6289-40d1-87b2-b57d6873953f	Tierra Café \t			2025-06-20 10:54:59.25	2025-06-20 10:54:59.25		CN-4409924		
69265f28-b1a6-4868-b881-b0a7f29dce90	Tierra Café \t			2025-06-20 10:55:02.023	2025-06-20 10:55:02.023		CN-4409924		
40a327e0-6b7d-4cc6-a993-3eb147bf1c94	Tierra Café \t			2025-06-20 10:56:42.39	2025-06-20 10:56:42.39		CN-4409924		
8d2c46dc-8377-4485-b6fc-ddbfdbbb8cd5	Tierra Café \t			2025-06-20 10:57:11.423	2025-06-20 10:57:11.423		CN-4409924		
a445a051-038d-44c8-bc35-9e38c910767d	Tierra Café \t			2025-06-20 10:57:38.214	2025-06-20 10:57:38.214		CN-4409924		
aad02873-b352-4d75-8b12-1e7a61d7211f	Tierra Café \t			2025-06-20 10:57:41.942	2025-06-20 10:57:41.942		CN-4409924		
35eb750c-6195-45d3-9113-5af393ad59bd	Burger Stop Cafeteria\t	50 233 3157		2025-06-20 11:02:27.007	2025-06-20 11:02:27.007		CN-2174527		
7b965a4c-77c8-47a5-829b-e77659d1bfe0	Rebel Foods/ Khalidya 			2025-06-20 12:44:26.782	2025-06-20 12:44:26.782		CN-3952321		
32773678-69fc-46a4-81d1-439bd28881e2	Rebel Foods/ Khalidya 			2025-06-20 12:44:34.386	2025-06-20 12:44:34.386		CN-3952321		
ec29a62c-2eb5-4e0c-9cbe-569b900d216d	Khalidiya Palace Rayhaan by Rotana	0502688511	hala.khalaf@rotana.com	2025-06-21 06:37:44.526	2025-06-21 06:37:44.526	Hala Khalaf		Cluster Learning and Development Manager	026570230 
b9810d1a-7cda-4d7b-8143-a405998b3d43	McDonald's			2025-06-21 06:55:33.554	2025-06-21 06:55:33.554				
491941ba-d538-48ed-9716-ad6e2ef2b4c4	McDonald's			2025-06-21 06:56:18.218	2025-06-21 06:56:18.218				
262a6a85-1a1b-4457-9040-abd9f13c9559	McDonald's			2025-06-21 06:56:46.213	2025-06-21 06:56:46.213				
7c8e68db-a7f7-49b7-88c4-10a346e36c59	McDonald's			2025-06-21 06:57:15.451	2025-06-21 06:57:15.451				
798f23a1-b52d-4a57-add6-3c0822cca472	McDonald's			2025-06-21 07:00:49.668	2025-06-21 07:00:49.668				
3499be08-78c6-4fbb-8eda-05e05f36dd7a	McDonald's			2025-06-21 07:01:15.555	2025-06-21 07:01:15.555				
8434c5a0-75e8-464b-8a9e-214c72594036	McDonald's			2025-06-21 07:01:48.144	2025-06-21 07:01:48.144				
b1e576aa-78c3-46f8-bd87-126d2a5a5be3	McDonald's			2025-06-21 07:02:17.193	2025-06-21 07:02:17.193				
2b803c30-d00c-47ea-9a2c-e2bd70bb0a4e	McDonald's			2025-06-21 07:03:32.067	2025-06-21 07:03:32.067				
63288458-5a0c-45d1-9b5a-75ae6c1ff186	McDonald's			2025-06-21 07:04:12.736	2025-06-21 07:04:12.736				
b03414b9-acb2-4ccb-a5b2-4ba029ddcbd9	McDonald's			2025-06-21 07:04:59.252	2025-06-21 07:04:59.252				
87bb89ac-304b-49c4-83cd-9289fb006587	Kitopi	0545413443	ibrahim.khalil@kitopi.com	2025-06-21 07:05:33.599	2025-06-21 07:05:33.599	Ibrahim Khalil 	CN-4428223	People Business Partner	043502000
a04d76da-ce06-48eb-b0eb-3a9950463ab4	McDonald's			2025-06-21 07:05:34.531	2025-06-21 07:05:34.531				
2cf05f68-0ef3-4d91-bf58-007ba81999a8	McDonald's			2025-06-21 07:06:15.662	2025-06-21 07:06:15.662				
9d6f7ae0-a080-4c17-9528-fcb3f8e42ad7	McDonald's			2025-06-21 07:06:54.431	2025-06-21 07:06:54.431				
7c5c0234-20cc-4e96-8fdf-6e96c58c667c	McDonald's			2025-06-21 07:07:28.896	2025-06-21 07:07:28.896				
c1681c46-0344-44fa-bde2-d82e4c1a0c03	Souq Al Jami			2025-06-21 07:08:50.824	2025-06-21 07:08:50.824				
d7ec4419-5a12-446b-af4b-ff03fd5d52d3	FASSCO Catering Services LLC	0524285341	arun.sangle@fasscointernational.com	2025-06-21 07:15:44.287	2025-06-21 07:15:44.287	Arun Sangle	CN-1560322	Human Resources & Training Manager	025019000 
dae8e4e0-37a2-42eb-9e1e-4f63561d8b33	OFFICER CITY			2025-06-21 07:24:53.057	2025-06-21 07:24:53.057				
9c167a92-7816-463d-99a9-f107b085406e	Al Wahda Mall			2025-06-21 07:26:58.619	2025-06-21 07:26:58.619				
273115d0-e92a-461f-b063-30ea33dd05f1	Adnoc Embassies Area			2025-06-21 07:27:46.273	2025-06-21 07:27:46.273				
d2560afb-c1b9-48a3-bffc-20c58ea9dc1c	Al Wahda Mall			2025-06-21 07:27:52.984	2025-06-21 07:27:52.984				
75a9f8a4-4d55-4557-9418-790e24710622	OFFICER CITY			2025-06-21 07:28:01.604	2025-06-21 07:28:01.604				
8f8acf3e-0059-4ac7-bf85-467dc16654dc	Adnoc mushirff			2025-06-21 07:30:16.732	2025-06-21 07:30:16.732				
86bd5394-40fc-4227-8ee6-75c4945bfb1f	Adnoc Police College			2025-06-21 07:31:02.976	2025-06-21 07:31:02.976				
1414d89f-f04a-4e30-b482-1c2c82770058	Adnoc Police College			2025-06-21 07:31:15.144	2025-06-21 07:31:15.144				
c6e669c6-38a6-45a5-8634-bc05ecea73b4	Bawabat Al sharq Mall			2025-06-21 07:31:51.34	2025-06-21 07:31:51.34				
7bace72b-8462-471e-8660-d4e7bdbb1180	Adnoc Mahawi			2025-06-21 07:32:27.301	2025-06-21 07:32:27.301				
a146e5dc-37c4-4098-a5aa-72a6754cc33b	Adnoc mushirff			2025-06-21 07:32:47.404	2025-06-21 07:32:47.404				
6fe98b74-4bf7-494b-a4d7-20bb2d66b7d7	Adnoc mushirff			2025-06-21 07:33:31.829	2025-06-21 07:33:31.829				
86dbc07a-96dc-4612-a99f-7eecd4cb43a6	Adnoc Corniche			2025-06-21 07:34:11.558	2025-06-21 07:34:11.558				
41a99bce-93b4-4d90-b6b1-a6c4611a8926	Al Bateen			2025-06-21 07:35:48.959	2025-06-21 07:35:48.959				
6d02eb4c-d0a7-4fec-862c-2e355f4b8927	Makani Mall			2025-06-21 07:36:55.056	2025-06-21 07:36:55.056				
85ead626-8573-476c-b629-81b4e92822f6	Adnoc Khalifa City South			2025-06-21 07:37:41.996	2025-06-21 07:37:41.996				
27cb7681-333c-4e45-a561-6d80a786c4c8	Adnoc al Bahia 			2025-06-21 07:38:20.542	2025-06-21 07:38:20.542				
80db2e90-4458-4aca-be1d-210943b5ae3c	Adnoc al Bahia 			2025-06-21 07:39:13.764	2025-06-21 07:39:13.764				
65dd624f-4c53-482a-8bc3-49b2fa3ce501	Adnoc Embassies Area			2025-06-21 07:39:57.684	2025-06-21 07:39:57.684				
c148a3ab-5d5b-444f-8edb-367ea1344ca4	Al seef village mall			2025-06-21 07:40:30.445	2025-06-21 07:40:30.445				
e0f569cc-0a3c-430b-82d5-eb6647e36114	Deerfields Mall			2025-06-21 07:41:16.475	2025-06-21 07:41:16.475				
c20ec36a-945b-4427-9967-c51493486f85	Cravia Abu Dhabi	0543555029	nabeel@cravia.com	2025-06-21 07:42:15.764	2025-06-21 07:42:15.764	Nabeel Mohammad Ismail 		QA Supervisor	044359555
c4e058e9-4cc6-47a2-98dc-75ac99fb858d	Adnoc Samha			2025-06-21 07:49:53.517	2025-06-21 07:49:53.517				
6417cdc7-d098-4e15-89e0-5fa575fc6b48	Adnoc Police College			2025-06-21 07:51:48.462	2025-06-21 07:51:48.462				
9599d187-b828-4588-bdf5-e9f252c6200c	Ramadan Ibrahim	0566336230		2025-06-21 08:35:05.151	2025-06-21 08:35:05.151	Ramadan Ibrahim			
84fa688c-ab5c-4556-8f5f-03332e39915b	Ramadan Ibrahim	0566336230		2025-06-21 08:35:34.189	2025-06-21 08:35:34.189	Ramadan Ibrahim			
bfa61ecf-c0e5-4c55-85b7-463b8360ecba	Unimar Building Cleaning Services	0524259737	admin@unimarcorp.com	2025-06-21 09:10:02.087	2025-06-21 09:10:02.087	Steffi			
b175599a-5938-4429-8965-1f09ed8cc6ed	Al Ain Rotana			2025-06-21 11:19:18.496	2025-06-21 11:19:18.496				
a91d5bca-4ee7-4d80-9f09-159be84fc55c	Al Ain Rotana			2025-06-21 11:19:49.915	2025-06-21 11:19:49.915				
a6d748d8-9735-4d59-8d1b-78a6e34b357a	Wood House Restaurant\t	58 826 1957		2025-06-21 11:22:23.694	2025-06-21 11:22:23.694		CN-2802330		
ec2e0650-a4cf-4fee-9277-295e0ee17cfd	Wood House Restaurant\t	58 826 1957		2025-06-21 11:22:33.065	2025-06-21 11:22:33.065		CN-2802330		
c230bacd-4d9e-478d-afc4-024bff764212	Wood House Restaurant\t	0588261957		2025-06-21 11:22:58.291	2025-06-21 11:22:58.291		CN-2802330		
e40622ae-009b-4bba-9b07-bf0a52128f0f	Salamander Restaurant\t	589210890		2025-06-21 11:24:50.08	2025-06-21 11:24:50.08		CN-4676828		
70267d88-eeea-48ee-95f1-d9ba7b028e3e	Salamander Restaurant	0589210890		2025-06-21 11:25:21.86	2025-06-21 11:25:21.86		CN-4676828		
4cac7317-757c-422e-8905-23820fec50a9	Trio Cafe	0542798894		2025-06-21 11:26:33.586	2025-06-21 11:26:33.586		CN-5122702		
8d14a945-29a5-4290-85f5-a3b220342ba7	Trio Cafe	54 279 8894		2025-06-21 11:27:27.191	2025-06-21 11:27:27.191		CN-5122702		
56fbe214-9a69-40d7-ac59-ba4c59a36349	Trio Cafe	54 279 8894		2025-06-21 11:30:25.172	2025-06-21 11:30:25.172		CN-5122702		
23584e95-d996-4f17-91da-435838300489	Al Sultan Markets and Bakery\t	 506230605		2025-06-21 11:33:22.527	2025-06-21 11:33:22.527		CN-1111903		
28417b1a-7f0a-44a5-b81c-353701f44cfb	Al Sultan Markets and Bakery	0506230605		2025-06-21 11:34:41.821	2025-06-21 11:34:41.821		CN-1111903		
1cd9f95c-be76-47cf-934e-ddaad7e77f81	La Brioche\t	 50 287 8919		2025-06-21 11:36:22.125	2025-06-21 11:36:22.125		CN-2802328		
3639d426-8e68-4790-9b6b-52c30eb5a7a3	Mang Philip Restaurant\t	 50 299 3470		2025-06-21 11:38:57.771	2025-06-21 11:38:57.771		CN-3881788		
4cbf79ac-c3e6-4609-93f0-00ad04f341c1	Al Barjeel Restaurant\t	 50 299 3470		2025-06-21 11:39:25.779	2025-06-21 11:39:25.779		CN-1126612		
391cc4c3-3a84-4d0d-84bd-8ee5e1414dba	Felicita Boutique For  Flowers\t	 54 204 4493		2025-06-21 11:41:58.117	2025-06-21 11:41:58.117		CN-4514593		
3b4222bb-4fd1-4e1b-991f-557900248db7	PizzaExpress UAE - Jordana Restaurants LLC	0559986013	vidya@pizzaexpress.ae	2025-06-21 11:46:55.095	2025-06-21 11:46:55.095	Vidya Mudaliar	CN-2618093	Head of HR and L&D	044248076
7ce6fc68-15e6-467d-8fa4-59750da5ec44	Patchi Abu Dhabi	0509932975	abdulraziq.m@patchi-ae.com	2025-06-21 12:01:24.761	2025-06-21 12:01:24.761	Abdul Raziq	CN-10194472	Document Controller	043388300
10dca983-904a-4c5a-b087-3a82ba6ea1cf	Emirates International Hospital\t	56 619 8010		2025-06-21 12:03:29.154	2025-06-21 12:03:29.154		CN-1112092		
6e22ea0b-1d37-4ca1-b2fc-75b94c64f8ed	Your Destination For Juices\t	52 580 4688		2025-06-21 12:05:19.824	2025-06-21 12:05:19.824		CN-2406521		
bea9fbcd-632f-425c-a900-d4d893bc414e	Emirates International Hospital\t	56 619 8010		2025-06-21 12:05:25.632	2025-06-21 12:05:25.632		CN-1112092		
3fe0ca4f-7d01-484f-8798-378793659503	Roukn Aleatemad Grills \t	557267518		2025-06-21 12:09:32.13	2025-06-21 12:09:32.13				
47671e6d-e23c-45d0-92b0-4e63fd751963	Roukn Aleatemad Grills \t	0557267518		2025-06-21 12:09:53.198	2025-06-21 12:09:53.198				
8b2b209b-1b1a-4b3d-8bca-31f7a5ab0171	Al Rowdha Restaurant\t	528493811		2025-06-21 12:11:01.827	2025-06-21 12:11:01.827		CN-1111985		
783cea06-2a74-447a-9163-65c73015c430	Al Rowdha Restaurant	0528493811		2025-06-21 12:11:45.224	2025-06-21 12:11:45.224		CN-1111985		
0e18b832-c558-4489-9656-ac11d58a320f	Shay  Sajha Café \t	50 765 5799		2025-06-21 12:13:58.363	2025-06-21 12:13:58.363		CN-5468335		
6b55d2fe-c6b8-407d-8238-20d9c986f613	Al Bait Al shami Restaurant & cafeteria\t	CN-1121837		2025-06-21 12:14:34.064	2025-06-21 12:14:34.064		CN-1121837		
882d06b1-a248-4d80-8ab8-ba61ec52629a	Al Bait Al shami Restaurant & cafeteria\t	50 785 5616/50 944 0595		2025-06-21 12:15:22.508	2025-06-21 12:15:22.508		CN-1121837		
d36bbdd7-687d-4971-986a-1a92a9d3fd75	Al Bait Al shami Restaurant & cafeteria\t	50 785 5616/50 944 0595		2025-06-21 12:15:26.959	2025-06-21 12:15:26.959		CN-1121837		
4708eff3-5583-43b1-8ee9-e5ece7cfe904	Al Bait Al shami Restaurant & cafeteria\t	50 785 5616/50 944 0595		2025-06-21 12:15:53.351	2025-06-21 12:15:53.351		CN-1121837		
9f9dffb8-051f-4d7f-a33f-1c0c345892d3	Twon Twenty café\t	501783887		2025-06-21 12:16:41.262	2025-06-21 12:16:41.262				
85935c96-5325-4114-b3ef-fac6018aab17	Al Qadhi Shaabi Restaurant \t	 50 638 3660		2025-06-21 12:17:24.85	2025-06-21 12:17:24.85		CN-1122662		
83f3df7a-7ded-48a2-81f0-00a4b4e54904	Al Qadhi Shaabi Restaurant \t	0506383660		2025-06-21 12:17:50.924	2025-06-21 12:17:50.924		CN-1122662		
73fa16fd-e597-4244-a77a-39c127bc04cd	Rose Mary Café \t	 56 724 4511/521980964		2025-06-21 12:20:18.191	2025-06-21 12:20:18.191		CN-1121929		
414b7c52-337c-4b4a-93f4-34d13df256fd	Adnoc MBZ-2			2025-06-23 06:55:39.716	2025-06-23 06:55:39.716		CN-1031673-54		
461cdeb3-58f1-42b5-8605-1ac443f5bcab	QRM-Quest Mgt Restaurant	0561540363		2025-06-21 12:21:23.912	2025-06-21 12:21:23.912	Reshma Kanakathidam 		Assistant – HR and Employee Services	026663567
c5838a84-6f78-4ee6-a8ca-96041a42a225	Harees  Al Majlis Traditional Food\t	 50 638 3660		2025-06-21 12:21:56.181	2025-06-21 12:21:56.181		CN-510085		
321c338e-7cbd-4cde-b914-add6de5ddfd9	Mang Philip Restaurant\t	 50 299 3470		2025-06-23 04:09:02.972	2025-06-23 04:09:02.972		CN-3881788		
4ed3b55e-752f-4827-9bbe-dc5883ba1ed3	Mang Philip Restaurant\t	 50 299 3470		2025-06-23 04:09:23.878	2025-06-23 04:09:23.878		CN-3881788		
6786b3de-8a35-4ad4-8e34-8ca76ec02920	Mang Philip Restaurant\t	 50 299 3470		2025-06-23 04:11:05.736	2025-06-23 04:11:05.736		CN-3881788		
b2a05525-f3cc-4fc1-aeba-9b9e684699e7	Mang Philip Restaurant\t	 50 299 3470		2025-06-23 04:13:44.252	2025-06-23 04:13:44.252		CN-3881788		
cb3772ca-5e8c-42d9-9f7f-a7cd829836f6	Bounce Middle East	0567517883	Menly@bounce.ae	2025-06-23 04:12:53.53	2025-06-23 04:13:44.828	Menly dela Rosa	CN-5162206	Team Leader	
cb2259e2-9a36-456c-90f1-235cf1f18497	Trio Cafe	0542798894		2025-06-23 04:17:28.158	2025-06-23 04:17:28.158		CN-5122702		
39df8768-bf61-4609-a581-30312c7589d4	Trio Cafe	54 279 8894		2025-06-23 04:20:39.413	2025-06-23 04:20:39.413		CN-5122702		
feb0c883-2ed8-4ccb-86f1-65df630e8d6e	Your Destination For Juices\t	52 580 4688		2025-06-23 04:23:51.704	2025-06-23 04:23:51.704		CN-2406521		
2ae26068-d394-4fe1-9d0e-37ffab8f7d27	Salamander Restaurant\t	589210890		2025-06-23 04:26:21.404	2025-06-23 04:26:21.404		CN-4676828		
857eafe6-fdeb-4552-bee9-68e373c8f6d5	Salamander Restaurant	0589210890		2025-06-23 04:27:55.871	2025-06-23 04:27:55.871		CN-4676828		
c0e7a9a2-a939-43dd-b52a-7260eb937683	Al Qadhi Shaabi Restaurant \t	 50 638 3660		2025-06-23 04:32:19.917	2025-06-23 04:32:19.917		CN-1122662		
a586df86-d442-4db5-a677-6c6399c53aa4	Al Qadhi Shaabi Restaurant \t	0506383660		2025-06-23 04:35:41.358	2025-06-23 04:35:41.358		CN-1122662		
2fa1295a-2fe9-4e50-b594-cb626bc6a12d	Shay  Sajha Café \t	50 765 5799		2025-06-23 04:40:14.965	2025-06-23 04:40:14.965		CN-5468335		
1cdf0a50-c91a-4093-9d8c-d48a11aa330a	Accor-Novotel, Adagio, Mercure	0547769257 	Mira-bou.GHANEM@accor.com	2025-06-23 04:42:41.866	2025-06-23 04:42:41.866	Mira Bou Ghanem	CN-2243404	Cluster Environment, Health & Safety Manager	025016041 
ba0906b5-1430-427a-8484-2d65bd297666	Al Bait Al shami Restaurant & cafeteria\t	CN-1121837		2025-06-23 04:42:50.799	2025-06-23 04:42:50.799		CN-1121837		
df7d0044-4eb7-45ff-a55d-29355d1dce70	Al Bait Al shami Restaurant & cafeteria\t	50 785 5616/50 944 0595		2025-06-23 04:45:25.407	2025-06-23 04:45:25.407		CN-1121837		
2b4eee07-d6db-48ba-a845-d5716b3b3a3a	Al Bait Al shami Restaurant & cafeteria\t	50 785 5616/50 944 0595		2025-06-23 04:51:53.088	2025-06-23 04:51:53.088		CN-1121837		
8ef46ed8-4e02-4473-821a-142eb3d25d9f	Harees  Al Majlis Traditional Food\t	 50 638 3660		2025-06-23 04:55:38.128	2025-06-23 04:55:38.128		CN-5110085		
d722781c-c863-4f51-8dfc-d1135ae153bd	La Brioche-Bawadi Mall	 50 287 8919		2025-06-23 04:59:46.428	2025-06-23 04:59:46.428		CN-1014195-17		
1db92c02-4262-4924-8190-25352a637b04	Souq Al Jami			2025-06-23 05:00:31.937	2025-06-23 05:00:31.937		CN-3732960		
3942869b-ebb0-497d-bb22-4f95a475fbb8	La Brioche-Bawadi Mall	 50 287 8919		2025-06-23 05:01:37.658	2025-06-23 05:01:37.658		CN-1014195-17		
02d74f8c-cb4f-4430-abc8-66adb810074e	McDonald's			2025-06-23 05:02:18.85	2025-06-23 05:02:18.85		CN-2743553		
d79c460b-749e-4b26-8b58-fb39a1ec4097	Adnoc Mahawi			2025-06-23 05:03:35.037	2025-06-23 05:03:35.037		CN-1031673-51		
0681964d-49d7-44b8-9259-3b4505b2fa50	Twon Twenty café\t	501783887		2025-06-23 05:04:24.894	2025-06-23 05:04:24.894				
1801cf74-a22c-4272-9440-f9da9a814a16	Al Wahda Mall			2025-06-23 05:04:56.01	2025-06-23 05:04:56.01		CN-1031673-8		
a764b3a6-3cda-4c2a-bc86-38ff3b0af323	Bawabat Al sharq Mall			2025-06-23 05:06:33.57	2025-06-23 05:06:33.57		CN-1031673-24		
d20ebeff-1314-4f0b-8f65-19228d6b7a32	Bawabat Al sharq Mall			2025-06-23 05:06:51.766	2025-06-23 05:06:51.766		CN-1031673-24		
f2d3367e-af23-402d-a37b-84930d33fd76	Dalma Mall 1			2025-06-23 05:08:03.578	2025-06-23 05:08:03.578		CN-1031673-32		
90ef8479-2a76-46d4-9c13-ec041956778c	Adnoc al Bahia 			2025-06-23 05:09:14.701	2025-06-23 05:09:14.701		CN-1031673-50		
3e894e12-33a2-48de-87d6-b07a5ea6bece	Wood House Restaurant\t	58 826 1957		2025-06-23 05:10:18.338	2025-06-23 05:10:18.338		CN-2802330		
1a5444b1-fcfe-4c59-8816-161712f2c3f9	Adnoc MBZ-2			2025-06-23 05:10:21.113	2025-06-23 05:10:21.113		CN-1031673-54		
f4b006fe-93e7-4d75-a3db-73dbbdcfbc91	Adnoc MBZ-3			2025-06-23 05:12:42.501	2025-06-23 05:12:42.501		CN-1031673-55		
81189dba-9b02-4c22-b3ce-205854bcfcd5	Wood House Restaurant\t	0588261957		2025-06-23 05:13:33.475	2025-06-23 05:13:33.475		CN-2802330		
06c369a7-05fa-4d8c-8090-b570d85efd95	McDonald's			2025-06-23 05:14:24.421	2025-06-23 05:14:24.421		CN-1031673-55		
8324eb26-00a1-459d-8c15-9ce9d55f7687	Adnoc MBZ-2			2025-06-23 05:15:11.407	2025-06-23 05:15:11.407		CN-1031673-54		
e0abe30c-d418-4b25-a33f-4e23e550eb3b	McDonald's			2025-06-23 05:15:54.848	2025-06-23 05:15:54.848		CN-1031673-28		
681db904-a532-41f9-af47-431b397d812d	McDonald's			2025-06-23 05:17:32.4	2025-06-23 05:17:32.4		CN-1031673-3		
df5e0f76-5cf6-417f-b29c-291caab71417	Roukn Aleatemad Grills \t	557267518		2025-06-23 05:17:56.554	2025-06-23 05:17:56.554		CN-1125121-5		
7ce06710-be35-4104-99ab-6e51dc2e72e2	McDonald's			2025-06-23 05:19:41.073	2025-06-23 05:19:41.073		CN-103167355		
dc3c1971-316e-4b3d-b548-38e381288fcd	McDonald's			2025-06-23 05:20:40.583	2025-06-23 05:20:40.583		CN-5420778		
32ac2f5a-70ee-4a7d-8283-4afbd64fc2b3	Roukn Aleatemad Grills \t	0557267518		2025-06-23 05:21:14.616	2025-06-23 05:21:14.616		CN-1125121-5		
d930a991-ab0a-40c4-8aac-bcd2f9bcdd59	Al Rowdha Restaurant\t	528493811		2025-06-23 05:28:16.212	2025-06-23 05:28:16.212		CN-1111985		
69838e6e-bdce-4559-b660-6f3c9e2bfd31	Al Rowdha Restaurant	0528493811		2025-06-23 05:30:25.966	2025-06-23 05:30:25.966		CN-1111985		
be168586-5771-404d-bf87-bfcea184ce83	Adnoc MBZ-2			2025-06-23 05:35:28.759	2025-06-23 05:35:28.759		CN-1031673-54		
5c5ec1ad-59a7-4e8c-bd6c-46c24c1faad2	Adnoc Samha			2025-06-23 05:37:02.341	2025-06-23 05:37:02.341		CN-5420778		
0245a768-7562-4e04-88a8-cf0fbd5d1d9f	Al Wahda Mall			2025-06-23 05:37:33.283	2025-06-23 05:37:33.283		CN-1031673-8		
123b5140-83f5-421a-a182-c83a2b4ee36b	Adnoc MBZ-3			2025-06-23 05:38:39.637	2025-06-23 05:38:39.637		CN-103167355		
0e434c17-9c0b-493e-a3f6-c2079841ddbb	Al Jarf			2025-06-23 05:39:33.976	2025-06-23 05:39:33.976		CN-1031673-28		
be0e0951-f4de-4f92-aec6-9604df5b5ad3	Sambrial Restaurant			2025-06-23 05:40:45.25	2025-06-23 05:40:45.25		CN-5785343		
4bb4381e-2f60-43ab-b8b3-99798d7b1d23	Al Sultan Markets and Bakery\t	 506230605		2025-06-23 05:47:33.553	2025-06-23 05:47:33.553		CN-5468335		
b354ba49-4b84-4289-850d-a07af125aff3	Al Sultan Markets and Bakery	0506230605		2025-06-23 05:51:25.488	2025-06-23 05:51:25.488		CN-1111903		
7b7f830a-f4cc-44ff-a8ae-b3c98a423b81	Al Jarf			2025-06-23 05:53:24.159	2025-06-23 05:53:24.159		CN-1031673-28		
0103145f-af42-4754-a697-e6b3ca991646	.			2025-06-23 05:54:21.466	2025-06-23 05:54:21.466				
9bc6df0d-41a7-466d-a7c1-1ba20d5c417b	.			2025-06-23 05:54:52.799	2025-06-23 05:54:52.799				
c732f5f0-48a3-4622-8f27-c8debb5dbbf8	.			2025-06-23 06:03:25.262	2025-06-23 06:03:25.262				
a55dd4da-7ad5-4008-a2a6-934662c9c69a	Branch 			2025-06-23 07:05:22.815	2025-06-23 07:05:22.815		CN-5773397		
7ab01bb5-a9dc-4ccb-889e-03537431ef25	Al Jarf			2025-06-23 07:53:33.464	2025-06-23 07:53:33.464		CN-1031673-28		
ee3a0e2f-1191-4de5-816e-633e29853ea5	Your Destination For Juices\t	52 580 4688		2025-06-23 08:12:28.584	2025-06-23 08:12:28.584		CN-2406521		
0a14c665-c903-42c0-98e8-c6afd6e7833a	Al Qadhi Shaabi Restaurant \t			2025-06-23 08:57:28.409	2025-06-23 08:57:28.409		CN-1122662		
78a464ce-6410-41f1-bbc4-3712b1ce85d5	Al Qadhi Shaabi Restaurant \t			2025-06-23 08:57:33.051	2025-06-23 08:57:33.051		CN-1122662		
caa91c99-7330-4fcf-b1de-ddc490ab6ed3	Bangla Baraka Restaurant 			2025-06-23 08:57:59.882	2025-06-23 08:57:59.882				
19b17344-dec6-4c61-8041-1ec445822f92	Bangla Baraka Restaurant 			2025-06-23 08:58:22.348	2025-06-23 08:58:22.348		CN-1125545		
2aa69a13-b451-414b-b164-7ad1e105931b	Al Qadhi Shaabi Restaurant \t	0564233660		2025-06-23 09:03:22.776	2025-06-23 09:03:22.776		CN-1122662		
c1c7ee6f-480d-450c-886e-66978b3a2086	Bangla Baraka Restaurant 	543902032		2025-06-23 09:09:47.039	2025-06-23 09:09:47.039		CN-1125545		
8bd6cd25-f24e-4a30-8b5f-2dcd068b2028	Al Qadhi Shaabi Restaurant \t	0564233660		2025-06-23 09:11:03.423	2025-06-23 09:11:03.423		CN-1122662		
5fb53956-fada-4188-9bb2-a42fcc42e142	Bangla Baraka Restaurant 	543902032		2025-06-23 09:11:25.118	2025-06-23 09:11:25.118		CN-1125545		
f6f9fcb1-fb62-4cf5-a2da-9a55a4c71b40	Bangla Baraka Restaurant 	543902032		2025-06-23 09:11:28.809	2025-06-23 09:11:28.809		CN-1125545		
9e51fb61-0da2-4331-9cd6-a7f9a88bd167	Wood House Restaurant\t	58 826 1957		2025-06-23 09:55:18.553	2025-06-23 09:55:18.553		CN-2802330		
4fae2d35-fee1-465b-b17e-74c5fdb04bfe	Ishq Grocery	55 972 0275		2025-06-23 09:57:51.52	2025-06-23 09:57:51.52		CN-3686414		
5e065ac3-49c6-4d85-b371-fdd5a32ad813	Ishq Grocery	55 972 0275		2025-06-23 09:59:26.542	2025-06-23 09:59:26.542		CN-3686414		
4410ee96-e182-45e2-b47d-7a2e46cee85e	Wood House Restaurant\t	58 826 1957		2025-06-23 10:00:26.259	2025-06-23 10:00:26.259		CN-2802330		
fcafc2b0-6db5-4bc3-8075-9e8b25aa5543	Wood House Restaurant\t	0588261957		2025-06-23 10:01:04.562	2025-06-23 10:01:04.562		CN-2802330		
78d7d1c0-6af4-487c-8ab9-42bf1d8bd3fa	Trio Cafe	54 279 8894		2025-06-23 10:02:50.638	2025-06-23 10:02:50.638		CN-5122702		
88516212-f941-45f3-970e-a1f0349b6dba	Roukn Aleatemad Grills \t	0557267518		2025-06-23 10:08:00.137	2025-06-23 10:08:00.137		CN-1125121-5		
536049e0-050d-4db4-a876-705a66c54437	Al Rowdha Restaurant\t	528493811		2025-06-23 10:08:52.181	2025-06-23 10:08:52.181		CN-1111985		
9ae6afab-6860-469f-b8b4-3b52e5182ef3	Peshawari Food Restaurant \t	562464045    		2025-06-23 10:28:45.75	2025-06-23 10:28:45.75		CN-5489476		
fb078426-a9c8-47f1-b288-3691a53840ed	Pure Brown Chocolates	 50 566 9136		2025-06-23 10:58:52.796	2025-06-23 10:58:52.796				
b375a5ea-f38c-4967-a396-0654dcf9eb43	Peshawari Food Restaurant \t	562464045    		2025-06-23 11:04:25.347	2025-06-23 11:04:25.347		CN-5489476		
d5adef5b-326c-424f-872b-cc9d94938def	Sofra Baniyas Restaurant\t	56 352 3882		2025-06-23 11:06:04.43	2025-06-23 11:06:04.43		CN-5130721		
73fc166f-e3f8-4e95-ba23-c7d49184313d	Electra Branch 			2025-06-23 11:11:01.365	2025-06-23 11:11:01.365				
76cafe81-d77e-431f-a1a6-2b17119e019f	Best Biriyani Restaurant\t	 50 913 2332		2025-06-23 11:11:12.503	2025-06-23 11:11:12.503		CN-2782694		
e06a3c7c-96c1-4bc7-b926-b9108d940e50	Best Biriyani Restaurant\t	 50 913 2332		2025-06-23 11:12:46.353	2025-06-23 11:12:46.353		CN-2782694		
270c17c6-6099-4925-9168-e3a67422609a	Best Biriyani Restaurant\t	 50 913 2332		2025-06-23 11:14:09.727	2025-06-23 11:14:09.727		CN-2782694		
f3223e40-e110-40d5-b165-617eb364afec	BesByte African Restaurant	 52 483 0568		2025-06-23 11:16:08.13	2025-06-23 11:16:08.13		\t\tCN-3983803		
0abaec0f-36a9-4217-9a29-ab9470801618	Rotana 			2025-06-23 11:16:47.895	2025-06-23 11:16:47.895				
4a048cd0-54b3-4628-ab0f-9f566b025486	Rotana			2025-06-23 11:17:01.227	2025-06-23 11:17:01.227				
cebbf7f2-4a25-4754-b0f2-78f5291c8ade	Sofra Baniyas Restaurant\t	56 352 3882		2025-06-23 11:17:53.354	2025-06-23 11:17:53.354		CN-5130721		
75064c58-702f-498c-8c8b-a968541382df	Rotana			2025-06-23 11:20:25.068	2025-06-23 11:20:25.068				
3bae47ee-93aa-4a75-ab73-f3f92922428d	Rotana			2025-06-23 11:20:36.522	2025-06-23 11:20:36.522				
bbf3b89c-04e0-4b80-8fa3-34cbef7a4d5b	Zad Al Khair Catering \t	 50 847 1618		2025-06-23 11:22:08.991	2025-06-23 11:22:08.991				
613d32d2-3293-42c4-9f8c-764af4575a45	Zad Al Khair Catering \t	 50 847 1618		2025-06-23 11:22:17.368	2025-06-23 11:22:17.368				
f34cb39a-b6b8-4c5e-8966-f6361f0faf97	Zad Al Khair Catering \t	 50 847 1618		2025-06-23 11:22:27.979	2025-06-23 11:22:27.979				
6e574e05-c37b-4588-8c02-bff83857600c	Zad Al Khair Catering \t	 50 847 1618		2025-06-23 11:22:38.022	2025-06-23 11:22:38.022				
4d5bbf50-31be-4d88-87e9-d864b0a11218	Zad Al Khair Catering \t	 50 847 1618		2025-06-23 11:22:42.57	2025-06-23 11:22:42.57				
bd918b64-6462-47d2-9bf5-25820b8d88bd	Rotana			2025-06-23 11:23:06.53	2025-06-23 11:23:06.53				
877adb38-fc8b-408d-a47a-de9e1d0dafcd	Rotana			2025-06-23 11:23:20.758	2025-06-23 11:23:20.758				
0420d83f-0fb5-4d99-87ff-bb959bd9f815	Gyma 			2025-06-23 11:25:15.556	2025-06-23 11:25:15.556				
a00f2c14-10f1-462c-89f1-2a191322424e	Green House 			2025-06-23 11:26:26.1	2025-06-23 11:26:26.1				
e1b41728-ec7b-468c-8046-05d3b38bdec7	Gre			2025-06-23 11:26:54.391	2025-06-23 11:26:54.391				
e209163c-3a8e-44af-b10b-967a1abbe34e	Green House 			2025-06-23 11:27:32.265	2025-06-23 11:27:32.265				
9f79277a-f167-4ff8-8270-f018cae5a43a	Patchi			2025-06-23 11:28:50.714	2025-06-23 11:28:50.714				
57caf293-051d-49b5-bbbf-32739792051b	Patchi			2025-06-23 11:29:17.111	2025-06-23 11:29:17.111				
803bd1fb-9618-4206-8900-655f89bdba8a	Patchi			2025-06-23 11:29:50.854	2025-06-23 11:29:50.854				
6c8a9215-2c49-4bbd-a84e-74dc2c8fc493	Patchi			2025-06-23 11:29:56.648	2025-06-23 11:29:56.648				
46cd49f3-154d-4a98-a7de-b395ad89b5e6	Patchi			2025-06-23 11:30:02.185	2025-06-23 11:30:02.185				
6c6d98c5-ecae-4eb3-83be-780e2e49fa1a	Al Maya			2025-06-23 11:30:22.431	2025-06-23 11:30:22.431				
5a4b7c01-472d-4494-8466-b3ab8436c636	Al Rahi Baqala 			2025-06-23 11:37:44.952	2025-06-23 11:37:44.952				
1c10433b-0080-404e-8943-98df4a322457	Personal 			2025-06-23 12:00:26.112	2025-06-23 12:00:26.112				
d67d4500-46d2-4a2a-b002-976d7f1c91c3	Mohammed Rasool Khoory & Sons	0501091273	richard@mrkhoory.ae	2025-06-23 12:19:14.283	2025-06-23 12:19:14.283	Richard Linget	CN-1002149	Operation Officer	026222200
0c700302-dfbd-4527-8353-088f92b4557f	Golden Dalla Meals			2025-06-23 13:05:42.942	2025-06-23 13:05:42.942				
bc3955aa-27d5-49dd-8466-08c583ccffdf	Golden Dalla Meals			2025-06-23 13:05:52.262	2025-06-23 13:05:52.262				
2258292e-7f99-4102-a2e3-683528d04ee9	Golden Dalla Meals			2025-06-23 13:06:54.957	2025-06-23 13:06:54.957				
18304b12-0d63-465c-b598-29119bfe0a58	Branch 			2025-06-23 13:11:06.439	2025-06-23 13:11:06.439				
01391824-ab17-494b-8d75-21b90ecf1002	Mohd Rasool Khoory 			2025-06-23 13:22:22.654	2025-06-23 13:22:22.654				
d9a8c536-9b07-48fd-90e4-2834bee3694e	Rolled Leaves Mahashi 			2025-06-23 13:55:14.278	2025-06-23 13:55:14.278		CN-1657624		
e48e9d54-7081-49cc-b602-dcc3b6474afe	Trio Cafe 			2025-06-24 04:17:27.657	2025-06-24 04:17:27.657		CN-5122702		
006d61d5-eb21-4b10-bc53-00050910111a	Trio Cafe 			2025-06-24 04:17:31.801	2025-06-24 04:17:31.801		CN-5122702		
38090a8c-8fc2-48ce-9b03-791a37ff5d74	Walaem Hadramaut Restaurant\t			2025-06-24 04:22:31.317	2025-06-24 04:22:31.317		CN-5270068		
497a0725-21d6-413d-9b1f-cd27efedc33c	Walaem Hadramaut Restaurant\t			2025-06-24 04:23:11.099	2025-06-24 04:23:11.099		CN-5270068		
d8a7da56-5ea2-4758-921f-a8dd3338f290	Hinoki Restaurant			2025-06-24 04:26:05.67	2025-06-24 04:26:05.67		CN-4705145		
85242ef2-33db-4c9b-83de-cb50e6026602	Hinoki Restaurant			2025-06-24 04:28:19.222	2025-06-24 04:28:19.222		CN-4705145		
ca3635d4-2e06-42bf-b752-247ac8172d98	Hinoki Restaurant			2025-06-24 04:28:22.939	2025-06-24 04:28:22.939		CN-4705145		
3e143751-b0a3-433e-8d33-6f2c87ce4bdb	Hinoki Restaurant			2025-06-24 04:28:31.249	2025-06-24 04:28:31.249		CN-4705145		
7b373a0b-1340-4cc0-9950-98228ede3008	Adnoc Embassies Area			2025-06-24 04:32:30.533	2025-06-24 04:32:30.533		CN-1031673-16		
a59b98c4-b018-4235-b87b-e23b26bafec6	Adnoc Corniche			2025-06-24 04:33:53.2	2025-06-24 04:33:53.2		CN-1031673-3		
adad227c-af03-4e82-965a-ed6a2e453ba8	Makani Mall			2025-06-24 04:35:35.567	2025-06-24 04:35:35.567		CN-1031673-38		
5b877b97-b1b1-4d5a-bc26-e2e47ac9cb7e	Bawabat Al sharq Mall			2025-06-24 04:36:35.794	2025-06-24 04:36:35.794		CN-1031673-24		
fee44029-b1cd-43ee-92f1-49fff1cec854	Top Five Restaurant			2025-06-24 04:37:12.954	2025-06-24 04:37:12.954		CN-1131386		
76b9c874-2d89-44e2-9827-ce00233d63ad	Al seef village mall			2025-06-24 04:38:10.365	2025-06-24 04:38:10.365		CN-1031673-30		
bdbf356f-10b1-433b-ae1c-75f5aa463d7d	Adnoc Mahawi			2025-06-24 04:38:56.374	2025-06-24 04:38:56.374		CN-1031673-51		
ca47fbee-28a6-47c4-ae31-d7ad472cc794	Top Five Restaurant			2025-06-24 04:39:50.806	2025-06-24 04:39:50.806		CN-1131386		
d50e2b44-772f-43bb-84fd-e81a9d6e69d8	Al Bateen 			2025-06-24 04:40:14.567	2025-06-24 04:40:14.567		CN-1031673-14		
9afd628a-7d6d-45ed-b9e6-343b37708f39	Al Bateen 			2025-06-24 04:40:23.966	2025-06-24 04:40:23.966		CN-1031673-14		
a1d6bfd1-2e08-48e0-be46-de0314a9605d	Bawabat Al sharq Mall			2025-06-24 04:42:02.545	2025-06-24 04:42:02.545		CN-1031673-24		
e0b48f4c-c1b1-4d5d-8a6c-1cfe77df62ec	Adnoc Mahawi			2025-06-24 04:43:35.783	2025-06-24 04:43:35.783		CN-1031673-51		
b29dcbeb-853c-45c1-8320-0380f584b0a5	Top Five Restaurant			2025-06-24 04:43:41.122	2025-06-24 04:43:41.122		CN-1131386		
5c868887-fc0d-4c20-a2a5-53177b884096	Green Lahore Darbar Restaurant 			2025-06-24 04:47:51.249	2025-06-24 04:47:51.249		CN-5426551		
277b5e10-28f9-46d3-a656-de199ae520ee	Gorat Qahwa Café \t			2025-06-24 04:52:41.212	2025-06-24 04:52:41.212		CN-2522627		
d54a55c6-0d76-45e0-8585-b3bfc7095ddb	Trio Cafe			2025-06-24 04:56:29.006	2025-06-24 04:56:29.006		CN-5122702		
1581450a-ae86-4122-a671-15c1af72caa8	Deep Cafe and Roastery 			2025-06-24 05:02:20.042	2025-06-24 05:02:20.042		CN-3966962		
88e43af7-7067-42b6-b7eb-bb119b684cca	Khaled Restaurant			2025-06-24 05:06:04.619	2025-06-24 05:06:04.619		CN-1102936		
0df486ee-cfae-48a0-ba3a-8a5921fa5d94	Walaem Hadramaut Restaurant\t			2025-06-24 05:13:24.419	2025-06-24 05:13:24.419				
be208648-1fa6-4b2c-b15f-b9bc867ac1c2	Walaem Hadramaut Restaurant\t			2025-06-24 05:13:28.298	2025-06-24 05:13:28.298				
9ced0105-b6d2-45d4-9477-fabb3994bbbb	Ared Alshawarma Cafeteria 			2025-06-24 05:18:19.542	2025-06-24 05:18:19.542		CN-3741102		
18057f7e-3b8a-4b01-a9a0-15597f4f0dde	Adnoc Samha			2025-06-24 05:23:05.343	2025-06-24 05:23:05.343		CN-5420778		
55df6916-abcd-42ca-b463-8e94ec754ae3	Deerfields Mall			2025-06-24 05:24:29.472	2025-06-24 05:24:29.472				
7a3e13ef-7bb9-4ee2-a816-7a06d0db1599	World Gate Baqala	582248919		2025-06-24 05:27:57.514	2025-06-24 05:27:57.514		CN-5201370		
7b29bc63-0d6b-4abf-b56a-5cac94e2fe00	Just Fresh Juice Cafeteria			2025-06-24 05:41:52.523	2025-06-24 05:41:52.523		CN-5495690		
33634a0e-172f-4dbc-8d37-c273b6a9c7ed	Walaem Hadramaut Restaurant\t			2025-06-24 05:44:22.523	2025-06-24 05:44:22.523		CN-5270068		
99dc0f65-9b0e-4882-a10c-0060b6c2d027	Hinoki Restaurant			2025-06-24 05:49:05.294	2025-06-24 05:49:05.294		CN-4705145		
93f6f934-9248-471c-bb96-b14186235b6d	Trio Cafe			2025-06-24 05:49:48.71	2025-06-24 05:49:48.71		CN-5122702		
064049d7-d508-4139-aef7-d6d1a219a9f5	Adnoc al Bahia 			2025-06-24 05:50:26.863	2025-06-24 05:50:26.863		CN-1031673-50		
5cf663e7-d6fe-4092-8e9d-bd98948fdc1e	Adnoc al Bahia 			2025-06-24 05:51:18.913	2025-06-24 05:51:18.913		CN-1031673-50		
ecc4a2f3-876e-44f0-8ac6-46cb1b833576	Walaem Hadramaut Restaurant\t			2025-06-24 05:52:50.849	2025-06-24 05:52:50.849		CN-5270068		
6722fcc9-dc17-447b-9b49-5ec29fa2f573	Adnoc mushirff			2025-06-24 05:53:10.36	2025-06-24 05:53:10.36		CN-1031673-43		
a47f38af-d6a5-4bb5-b0c7-8346b327b902	Adnoc mushirff			2025-06-24 05:54:33.244	2025-06-24 05:54:33.244		CN-1031673-43		
f6cf599c-7468-47eb-bbd8-8367b47ce160	Al seef village mall			2025-06-24 05:56:39.49	2025-06-24 05:56:39.49		CN-1031673-30		
154d60df-4ca8-4be4-8d20-ab9b4289ba74	Wood House Restaurant			2025-06-24 05:59:05.312	2025-06-24 05:59:05.312		CN-2802330		
5f482758-7b64-47c5-974b-b18d6fc9ef54	Wood House Restaurant			2025-06-24 06:04:14.036	2025-06-24 06:04:14.036		CN-2802330		
071d5b4c-fea5-4cff-b113-ad63452714e2	Adnoc mushriff			2025-06-24 06:08:19.659	2025-06-24 06:08:19.659		CN-1031673-43		
08d4de9f-27a8-46e8-8fe1-4820586f9052	Adnoc mushriff			2025-06-24 06:08:43.737	2025-06-24 06:08:43.737		CN-1031673-43		
f251eea0-fbc8-4eb2-a86a-3d5ecab52dbd	The Cousins Catering 			2025-06-24 06:14:31.138	2025-06-24 06:14:31.138		CN-2579934		
adaf9d10-0549-41c6-ab34-c63e2b1df0f3	The Cousins Catering 	0543662266	cousinthe855@icloud.com	2025-06-24 06:15:44.513	2025-06-24 06:15:44.513		CN-2579934		
227a9685-d949-43f4-ba64-f7d3e987f248	Future Ride Scoot Shop 			2025-06-24 06:32:10.406	2025-06-24 06:32:10.406		CN-5573397		
5049eb2d-4d5e-4255-979e-14d32d5beae2	Lazord Café \t	54 742 7607		2025-06-24 06:36:04.207	2025-06-24 06:36:04.207		CN-1031379		
48f373d2-a9f5-4298-875d-c49702323fd5	Almarai Emirates Company LLC\t			2025-06-24 06:39:42.547	2025-06-24 06:39:42.547				
6587969f-30ef-498f-9a35-350c797f0b24	Almarai Emirates Company LLC\t			2025-06-24 06:39:53.672	2025-06-24 06:39:53.672				
e7271e0c-a48c-4fa6-a3c7-e7853110e6ec	Kitopi 			2025-06-24 06:41:52.135	2025-06-24 06:41:52.135				
76b5fcc1-f263-4823-b96a-8f1f6c75c39c	Future Ride Scoot Shop 			2025-06-24 06:52:27.601	2025-06-24 06:52:27.601		CN-5573397		
a98db176-89db-4a1b-9390-bec67614c5f3	Al Bateen Marina			2025-06-24 06:57:04.343	2025-06-24 06:57:04.343		CN-3723567		
aaf1d0f4-680b-4f0b-a33c-5aadfd5e53be	Al Raya Restaurant	91 96054 57494/971562757052		2025-06-24 06:57:14.72	2025-06-24 06:57:14.72		CN-1113179		
ba4ad0ed-b4bc-4b99-b8b4-3bbe2981753b	Al Khaleej Bakery 			2025-06-24 07:01:06.34	2025-06-24 07:01:06.34		CN-1111246		
22257ccf-c300-4bdf-a32f-c37d1aa8faff	Meena Market 	0501949332		2025-06-24 07:03:13.424	2025-06-24 07:03:13.424		CN-1717362		
7718bdf9-0785-4633-b815-ad3623f4c69c	Meena Market 	0501949332		2025-06-24 07:04:18.939	2025-06-24 07:04:18.939		CN-1717362		
7b3e94b1-921e-4693-bc3d-2d4feef517ef	Wood House Restaurant			2025-06-24 07:06:32.547	2025-06-24 07:06:32.547		CN-2802330		
187266f2-2a0f-4336-aafe-bc5ebcf80ded	Al Bateen Marina			2025-06-24 07:10:11.589	2025-06-24 07:10:11.589		CN-3723567		
8fa94882-4b3e-4da1-ac98-fcb8146c111c	Wood House Restaurant			2025-06-24 07:11:44.962	2025-06-24 07:11:44.962		CN-2802330		
ef689b73-2618-44fa-81c7-149466ca5030	Wood House Restaurant			2025-06-24 07:15:55.171	2025-06-24 07:15:55.171		CN-2802330		
246d3ca0-36c8-4561-a4dc-230260bc23a4	Corniche 			2025-06-24 07:17:57.544	2025-06-24 07:17:57.544		CN-1524157		
905b6de2-ca52-4ef1-b276-12949c4aeebb	Yas Mall 			2025-06-24 07:23:44.886	2025-06-24 07:23:44.886		CN-1876384		
f78ad432-8db1-4119-8d4d-b86de5422ffd	Bawabat Al sharq Mall			2025-06-24 07:24:47.369	2025-06-24 07:24:47.369		CN-1524157		
248e90ca-73d2-405a-b22c-d446c7490e9b	Mushriff Mall 			2025-06-24 07:25:35.627	2025-06-24 07:25:35.627		CN-1476715		
2d54c459-33bb-4486-9e9a-948f6db82bd4	FASSCO Catering/Cleveland 			2025-06-24 07:42:50.671	2025-06-24 07:42:50.671		CN-1560322		
6c7c91f0-9d23-45f6-b31c-94d29e4ac5c0	Bawabat Al sharq Mall			2025-06-24 07:49:45.111	2025-06-24 07:49:45.111		CN-1524157		
1987c1cc-30f5-4308-897d-6c808cf2f19c	Cleveland			2025-06-24 07:51:51.601	2025-06-24 07:51:51.601		CN-1560322		
55576abf-45b4-4422-9390-021ad14a1956	Bangla Baraka Restaurant \t			2025-06-24 11:25:57.575	2025-06-24 11:25:57.575				
aff6d04d-6c25-49ef-9e8a-38a22b523028	Bangla Baraka Restaurant \t			2025-06-24 11:26:02.915	2025-06-24 11:26:02.915				
97fdd8ff-0825-4445-b54c-bd72aeadf768	iml	56 118 0750		2025-06-24 11:33:42.761	2025-06-24 11:33:42.761				
d168f1bb-041f-437d-abc8-b323cf48ff04	Bangla Baraka Restaurant 	56 118 0750		2025-06-24 11:34:13.195	2025-06-24 11:34:13.195				
f22a473e-ca49-4f2c-8456-39f7ea3b5563	Felicita Boutique For  Flowers\t\t	54 204 4493		2025-06-24 12:16:28.324	2025-06-24 12:16:28.324		CN-4514593		
586f800a-f4cb-43e7-b33f-6b0e25bb94c1	Trio Cafe 			2025-06-25 04:09:22.494	2025-06-25 04:09:22.494		CN-5122702		
179d4b9b-5ac7-43ce-accb-7d718890e51b	Trio Cafe 			2025-06-25 04:12:28.124	2025-06-25 04:12:28.124		CN-5122702		
0b37def4-3ab9-4473-81a5-4c5d1eeb4f02	OFFICER CITY			2025-06-25 04:13:13.721	2025-06-25 04:13:13.721				
091576ce-42a3-449f-a339-5c6e263bcc13	Al Wa			2025-06-25 04:13:54.069	2025-06-25 04:13:54.069				
51ba3ed1-2109-4785-af2c-6d165de6b72b	Al Wahda Mall			2025-06-25 04:14:18.031	2025-06-25 04:14:18.031				
b34d468d-1f61-4882-a776-71111a5d359f	Adnoc Embassies Area			2025-06-25 04:14:59.488	2025-06-25 04:14:59.488				
22cfd79a-46e1-48c7-91a0-018e5c5ad96f	Adnoc al Bahia 			2025-06-25 04:15:45.688	2025-06-25 04:15:45.688				
46dae73c-01b0-471d-8eee-13a4f310681f	Central Mall			2025-06-25 04:16:51.427	2025-06-25 04:16:51.427				
bd5cf2af-a58a-4187-a9e3-019114794c24	Adnoc Tamouh 			2025-06-25 04:18:12.3	2025-06-25 04:18:12.3				
7e4f2d1f-4553-419e-a76e-866d68f503ae	Abudhabi Mall 1			2025-06-25 04:19:13.668	2025-06-25 04:19:13.668				
bb4f3417-e50f-40e5-81bd-50d058922390	Trio Cafe 			2025-06-25 04:20:28.007	2025-06-25 04:20:28.007		CN-5122702		
e87d43d3-dc5e-469c-930f-a1a4a5fef048	Adnoc Corniche			2025-06-25 04:20:35.887	2025-06-25 04:20:35.887				
ecac87a1-d81a-4dd5-a296-cb29fa1ac2b6	Adnoc Khalifa City South			2025-06-25 04:23:23.376	2025-06-25 04:23:23.376				
bee8b203-f7a7-45d0-96a1-e13a4b450bd8	La Brioche 			2025-06-25 04:24:37.562	2025-06-25 04:24:37.562		CN-1014195-17		
83933794-4a9b-4642-a0f7-15d69da0bdf4	Adnoc Samha			2025-06-25 04:25:06.334	2025-06-25 04:25:06.334				
c7e9d914-4aaf-44db-be0d-56332cac30c7	Adnoc Corniche			2025-06-25 04:26:13.831	2025-06-25 04:26:13.831				
e8f7247e-c663-482d-9ff8-a0217946b07f	Al Anqaa Grocery Shop \t			2025-06-25 04:26:24.746	2025-06-25 04:26:24.746		CN-1120915		
90e9f733-d014-4f81-a5a0-de550c32222c	Marina Mall 			2025-06-25 04:27:07.459	2025-06-25 04:27:07.459				
f8f1b46c-1931-4986-bd06-c112f081af3e	Adnoc Khalifa City South			2025-06-25 04:29:05.84	2025-06-25 04:29:05.84		CN-10367353		
c8de06b2-c65a-4674-b1f5-24cfa6b8da64	Al Anqaa Grocery Shop \t			2025-06-25 04:29:09.578	2025-06-25 04:29:09.578		CN-1120915		
78056932-10ad-4130-aea0-ae66ab8ec9f2	OFFICER CITY			2025-06-25 04:30:25.662	2025-06-25 04:30:25.662		CN-1031673-57		
05328e3e-192b-4f9c-83df-b15376fc2cd7	Lulu Al Sahra Food Stuff Stores L.L.C\t			2025-06-25 04:31:44.011	2025-06-25 04:31:44.011		CN-1116804		
0627d7b4-dc02-49b8-abcb-774c991eb8e0	Central Mall			2025-06-25 04:32:35.457	2025-06-25 04:32:35.457		CN-1031673-52		
040db08e-e2aa-4d97-9756-638a1c44a735	OFFICER CITY			2025-06-25 04:33:19.642	2025-06-25 04:33:19.642		CN-1031673-57		
3fe2a04b-eeec-44fb-a00b-793a2ea7c939	Lulu Al Sahra Food Stuff Stores L.L.C\t			2025-06-25 04:33:43.399	2025-06-25 04:33:43.399		CN-1116804		
8b9e79f2-225b-41ae-851d-a7c1b0d4df48	Adnoc Embassies Area			2025-06-25 04:34:12.041	2025-06-25 04:34:12.041		CN-1031673-16		
29bd39f2-0fdc-4968-bef8-be27fc10b8b3	Adnoc Corniche			2025-06-25 04:34:57.127	2025-06-25 04:34:57.127		CN-1031673-3		
e90d6299-7aed-4678-9718-ee207c24b0bf	Adnoc Corniche			2025-06-25 04:36:06.3	2025-06-25 04:36:06.3		CN-1031673-3		
edff5409-aee5-4d6e-9a3a-6fa0528aea34	Marina Mall 			2025-06-25 04:37:50.282	2025-06-25 04:37:50.282		CN-1031673-46		
76d74c8b-a24a-47bb-a806-7ac8d8807401	Central Mall			2025-06-25 04:38:27.379	2025-06-25 04:38:27.379		CN-1031673-52		
aab2f8a9-43d3-47bc-bb08-ff7ee11d90c6	Khalidiya street			2025-06-25 04:40:23.356	2025-06-25 04:40:23.356				
9ee784a5-a07d-4b23-a130-0be66cb581e0	Al Haj Vegetables & Fruits\t			2025-06-25 04:40:55.708	2025-06-25 04:40:55.708		CN-1102474-1		
5d080b14-7a9b-45d5-b1da-f9e94dd7ced9	Caboodle Pamper and Play			2025-06-25 04:43:02.974	2025-06-25 04:43:02.974		000000157		
68ba13ea-2855-4224-87f2-c1d7814b590d	Nassrat Al madena Grocery \t			2025-06-25 04:45:01.195	2025-06-25 04:45:01.195		CN-1117865		
d43b8a42-aaa2-48f9-9e44-f8b24e4be212	Nada Al Ain Grocery Shop \t			2025-06-25 04:49:07.429	2025-06-25 04:49:07.429		CN-1121836		
17d8c38b-a4b9-4696-a0d7-40b10a1dd6c9	Mazdar City			2025-06-25 04:51:32.975	2025-06-25 04:51:32.975				
1e93468a-7a30-4ff6-b19d-4b13edb34c16	Al Sanafer Grocery \t			2025-06-25 04:53:02.654	2025-06-25 04:53:02.654		CN- 1120713		
e687c180-c27b-420f-a67e-9c8c0b03fcdd	Al Sanafer Grocery \t			2025-06-25 04:55:24.555	2025-06-25 04:55:24.555				
a43a4187-acdc-40f3-842f-97efd5da84f0	Al Sanafer Grocery \t			2025-06-25 04:56:33.287	2025-06-25 04:56:33.287		CN- 1120713		
ca1ad693-0663-4119-a5a0-4034e6284050	Hamdan Street 			2025-06-25 04:57:03.147	2025-06-25 04:57:03.147		CN-1053112		
04cd47ed-c5fb-459d-9307-5e6e1fdc985c	Al Sanafer Grocery \t			2025-06-25 04:57:30.298	2025-06-25 04:57:30.298		CN- 1120713		
5893a90a-711a-4102-a5ce-3eb54410931f	Al Sanafer Grocery \t			2025-06-25 04:57:53.436	2025-06-25 04:57:53.436		CN- 1120713		
beae4cdd-a300-494a-831b-d7d1f1bffa19	Al Sanafer Grocery \t			2025-06-25 04:59:06.492	2025-06-25 04:59:06.492		CN- 1120713		
71977456-5835-4533-9a7e-01919362bf84	Officer City 			2025-06-25 04:59:34.929	2025-06-25 04:59:34.929				
da24e039-23c7-4ca3-9052-930badae33a3	Al Wahda Mall			2025-06-25 04:59:58.32	2025-06-25 04:59:58.32				
13c41973-6504-4544-9a36-008b636dfc54	Adnoc Embassies Area			2025-06-25 05:01:46.759	2025-06-25 05:01:46.759				
70388bbb-3803-4a2f-b125-d32b94c9d1d5	Adnoc al Bahia 			2025-06-25 05:02:14.146	2025-06-25 05:02:14.146				
120c2390-630e-4e02-9a1b-cf580ba7ad0f	Besbyte African Restaurant\t			2025-06-25 05:02:33.297	2025-06-25 05:02:33.297		CN-3983803		
b30ec0fd-ee38-45ce-a0e7-79d3af3bb84a	Central Mall			2025-06-25 05:03:16.686	2025-06-25 05:03:16.686				
0dc8280e-099b-4df9-b28e-0fcdbd97e63d	Adnoc Tamouh 			2025-06-25 05:04:15.287	2025-06-25 05:04:15.287				
1d6211f1-3e7b-429b-8e68-fcf98fb9b465	Heros never Die			2025-06-25 05:06:50.311	2025-06-25 05:06:50.311				
0b8e31aa-4349-4f36-8659-aa51c65d0e73	Just Fresh Juice Cafeteria\t			2025-06-25 05:08:51.959	2025-06-25 05:08:51.959		CN-5616743		
2f7f02bc-2642-4a9a-aec5-586dcd162dcb	Heros never Die			2025-06-25 05:09:13.799	2025-06-25 05:09:13.799				
dff49d16-642b-41cb-82c5-031fd521f095	Mazdar City			2025-06-25 05:10:50.741	2025-06-25 05:10:50.741				
9bf0bfc4-7780-4799-9e65-e4343b8df142	Just Fresh Juice Cafeteria			2025-06-25 05:12:56.364	2025-06-25 05:12:56.364		CN-5616743		
e9b86738-8401-412d-aa0a-7baa65a10118	Heros never Die			2025-06-25 05:16:12.631	2025-06-25 05:16:12.631				
c5c46fad-b415-482c-921e-cab64573baaa	Eithar grocery\t			2025-06-25 05:17:02.563	2025-06-25 05:17:02.563		CN-1119374		
39e5b435-b1da-4527-b677-e09aca7fdde5	Heros never Die			2025-06-25 05:17:41.166	2025-06-25 05:17:41.166				
bec594ea-2c18-4041-9541-864019b0a9cf	Monaco Stars and Bars 			2025-06-25 05:19:31.941	2025-06-25 05:19:31.941				
7df1bc7c-c8ea-4046-88fe-91500831686f	Monaco Stars and Bars 			2025-06-25 05:21:08.723	2025-06-25 05:21:08.723				
961645e7-b44d-4e3e-bb5e-b0ffb58fe2c6	Alafdaliya General Trading\t			2025-06-25 05:25:35.569	2025-06-25 05:25:35.569		CN-4544205		
3a479f4b-9e9b-44b3-b2dd-17af7b7e6a2f	Just Fresh Juice Cafeteria			2025-06-25 05:49:01.866	2025-06-25 05:49:01.866		CN-5616743		
9a80b8e8-2fdc-4e5a-b9a7-bc0c6cdd7b54	Abudhabi Mall 1			2025-06-25 05:52:19.319	2025-06-25 05:52:19.319		CN-1031673-5		
e7a4b52a-f0fb-42c2-9416-3da8647cfcd1	Zahrathul Murijib grocery \t	504142227		2025-06-25 06:01:06.357	2025-06-25 06:01:06.357		CN-4366902		
bd675333-c217-4b68-835f-69f1db161c19	Officer City 			2025-06-25 06:01:41.597	2025-06-25 06:01:41.597				
439485a6-57e1-4ac0-9f0c-4c11ea05e009	Al Wahda Mall			2025-06-25 06:02:00.451	2025-06-25 06:02:00.451		CN-1031673-8		
d985aa18-890e-4075-b3a5-ea866b1a0668	Adnoc Embassies Area			2025-06-25 06:02:19.079	2025-06-25 06:02:19.079		CN-1031673-16		
5096293e-b392-4c23-a611-50a73a3400f3	Adnoc al Bahia 			2025-06-25 06:02:48.884	2025-06-25 06:02:48.884				
b8f4ff9d-040f-4708-b238-355e9118d14a	Just Silver Cafeteria	56 956 4786		2025-06-25 06:03:49.785	2025-06-25 06:03:49.785				
5c459c23-7ea1-4536-b120-313d6af7ae47	Adnoc al Bahia 			2025-06-25 06:03:59.889	2025-06-25 06:03:59.889		CN-1031673-50		
8f041472-e4e9-413f-b8a6-67a119d093ba	Adnoc Tamouh 			2025-06-25 06:05:14.076	2025-06-25 06:05:14.076		CN-2779104		
eb3947e2-26fd-478f-86f2-c1f139ab0fe6	Abudhabi Mall 1			2025-06-25 06:05:53.039	2025-06-25 06:05:53.039		CN-1031673-5		
7f357ab5-a8e6-4957-a23f-32c3981de3a3	Adnoc Corniche			2025-06-25 06:06:19.086	2025-06-25 06:06:19.086				
66618967-c3c6-4c04-b9ca-a22516971448	Bawabat Al sharq Mall			2025-06-25 06:09:12.623	2025-06-25 06:09:12.623		CN-1031673-24		
aa53fb1c-0e4b-417a-bceb-dbb0c4d6f811	Adnoc Khalifa City South			2025-06-25 06:11:17.999	2025-06-25 06:11:17.999				
543abe7a-28cb-4d11-a581-0c183ef959a5	Adnoc Khalifa City South			2025-06-25 06:11:27.636	2025-06-25 06:11:27.636				
a6e7018a-ca76-46e0-82f0-7ebeb0e107a3	Adnoc Samha			2025-06-25 06:13:23.899	2025-06-25 06:13:23.899				
3af8a2a4-d607-4313-ae7d-3643b8f37170	Adnoc Corniche			2025-06-25 06:21:16.554	2025-06-25 06:21:16.554		CN-1031673-3		
8a1bdd61-677a-4c4e-9a48-2b5897cf5799	Adnoc Corniche			2025-06-25 06:38:35.401	2025-06-25 06:38:35.401		CN-1031673-3		
edd5e6df-3053-4168-903e-dac98c21f40f	Marina Mall 			2025-06-25 06:40:32.292	2025-06-25 06:40:32.292				
fb4b3742-0c98-4db8-85f1-2e24d2d1a3ee	Khalidiya street			2025-06-25 06:41:46.776	2025-06-25 06:41:46.776		CN-1031673-4		
f99255e3-0e52-4676-b464-9ae7816b9215	World Trade Center 			2025-06-25 06:43:02.7	2025-06-25 06:43:02.7		CN-1031673-40		
d1d06133-fdd3-4091-802d-31cdba8ca19c	World Trade Center 			2025-06-25 06:44:10.004	2025-06-25 06:44:10.004		CN-1031673-40		
40b404a8-3dbe-43c0-8b3d-93e4d3e06795	Khalidiya street			2025-06-25 06:46:16.487	2025-06-25 06:46:16.487		CN-1031673-4		
a4124930-6ba3-4971-ab9e-95fc8b9d904d	Adnoc Samha			2025-06-25 06:48:00.863	2025-06-25 06:48:00.863		CN-5420778		
6b3bee8c-5057-4ada-90d3-454c8c6c575b	Adnoc Khalifa City South			2025-06-25 06:48:26.135	2025-06-25 06:48:26.135				
bf88d334-8b9e-4339-b2dc-19f97beec9a7	Adnoc Corniche			2025-06-25 06:49:03.919	2025-06-25 06:49:03.919		CN-1031673-3		
41b3edf8-e24b-47f5-8d17-2d62c6d8c320	Bawabat Al sharq Mall			2025-06-25 06:49:55.475	2025-06-25 06:49:55.475		CN-1031673-24		
384fe9a0-2d0a-491d-8aa2-c9314802913d	Officer City 			2025-06-25 06:50:22.674	2025-06-25 06:50:22.674				
a3960a87-be6b-427a-a9c1-a7d3ef130cea	Al Wahda Mall			2025-06-25 06:52:28.201	2025-06-25 06:52:28.201		CN-1031673-8		
54fbb4b6-c51e-41f3-b44a-577130783c86	World Trade Center 			2025-06-25 06:53:19.964	2025-06-25 06:53:19.964		CN-1031673-40		
0c081001-025e-47d5-b46a-90bbd54b67bc	The Heaf Cafe	0581372299	mira@theheaf.com	2025-06-25 07:06:40.59	2025-06-25 07:06:40.59	Mira Yunitasari		General Manager	
ae71c09e-66b2-4b14-aea5-375d6018a0ec	Just Break Cafeteria\t	50 219 3600		2025-06-25 07:07:00.282	2025-06-25 07:07:00.282		CN-5675932		
46e148e5-2071-4fea-a552-7b7af65f0e1f	Caboodle Pamper and Play			2025-06-25 07:09:11.919	2025-06-25 07:09:11.919		000000157		
56b282e6-bf0a-43e6-81ff-653c97f31137	Electra			2025-06-25 07:12:21.26	2025-06-25 07:12:21.26		CN-2243984		
c41094ac-3ca9-4c10-9943-5d6b5cef5a9b	Electra			2025-06-25 07:14:39.307	2025-06-25 07:14:39.307		CN-2243984		
15da959b-a9db-428e-893c-00a6dd27cb9d	Electra			2025-06-25 07:15:14.754	2025-06-25 07:15:14.754		CN-2243984		
d25bf732-1194-48a0-8525-40bb33168bcd	Electra			2025-06-25 07:16:06.491	2025-06-25 07:16:06.491		CN-2243984		
c74b1992-0a9d-40e3-8c80-09091f42587d	Mazdar City			2025-06-25 07:19:00.291	2025-06-25 07:19:00.291				
d8384e8d-d199-4cd7-ae07-7988ccb04a29	Mazdar City			2025-06-25 07:56:36.865	2025-06-25 07:56:36.865		CN-3991510		
2ad3ff57-8ada-40db-9b63-9975481a4df3	Mazdar City			2025-06-25 07:57:20.131	2025-06-25 07:57:20.131		CN-3991510		
4c744a0e-b8c1-41f8-b09e-10053cf7e5f0	Mazdar City			2025-06-25 07:57:36.771	2025-06-25 07:57:36.771		CN-3991510		
9130c019-bb2f-4458-b68b-7db99dcbdb1b	Bawabat Al sharq Mall			2025-06-25 08:45:57.112	2025-06-25 08:45:57.112		CN-1031673-24		
90f19fd4-924f-42b5-baf0-a612015f61c4	Bawabat Al sharq Mall			2025-06-25 08:46:19.149	2025-06-25 08:46:19.149		CN-1031673-24		
14cb8431-ce6c-4e1c-acac-032e546c03c7	Adnoc Khalifa City South			2025-06-25 08:49:57.334	2025-06-25 08:49:57.334		CN-1031673-53		
ed1340a6-3883-4d65-aaa2-53603d6db760	Fiesta Avenue Restaurant			2025-06-25 09:07:07.627	2025-06-25 09:07:07.627	Jerson Wycoco			
da9d26ac-e535-4fdb-b45f-7e1dad2685b4	Fiesta Avenue Restaurant			2025-06-25 09:08:08.734	2025-06-25 09:08:08.734				
50953ffa-88f8-4def-bfba-ebc5562a3027	Fiesta Avenue Restaurant			2025-06-25 09:24:52.247	2025-06-25 09:24:52.247				
78428ac0-162a-4c53-9de5-b5a62aed2c39	Ayla Hotels & Resort			2025-06-25 10:15:13.366	2025-06-25 10:15:13.366				
8d672d4e-5709-473f-b6e1-89a5448eba98	Ayla Hotels & Resort			2025-06-25 10:15:39.285	2025-06-25 10:15:39.285				
77a791b0-2edf-4931-bf26-b12b184046e9	Ayla Hotels & Resort			2025-06-25 10:15:59.825	2025-06-25 10:15:59.825				
da639222-4ce5-49ba-acdc-2462527e6733	ayla	anusha		2025-06-25 10:31:04.062	2025-06-25 10:31:04.062				
3b627a08-ce59-4ac6-9263-339bd619351d	ayla	anusha		2025-06-25 10:31:16.686	2025-06-25 10:31:16.686				
22c7eb35-3e55-441e-8f9e-c66012d62e94	ayla	anusha		2025-06-25 10:31:29.407	2025-06-25 10:31:29.407				
4e6a1994-e0de-42c1-a9d2-349edb289622	Ayla Hotels & Resort	Anusha		2025-06-25 10:31:47.43	2025-06-25 10:31:47.43				
8ee6cffd-5f67-4a5b-9fd7-4b90fd20fbe0	Electra			2025-06-25 10:42:38.985	2025-06-25 10:42:38.985		CN-2243984		
4ac24787-3b0d-446b-b2b1-b2a111fbc379	Mazdar City			2025-06-25 10:43:27.163	2025-06-25 10:43:27.163		CN-3991510		
dd45cae9-9146-43fe-a949-02344a13fd89	Officer City 			2025-06-25 10:44:15.917	2025-06-25 10:44:15.917		CN-1031673-57		
3d34f15b-5acf-4272-9485-0cfe20837cfe	Tierra Café	52 763 2334-farsana		2025-06-25 11:33:15.294	2025-06-25 11:33:15.294				
971d0388-97bf-4889-8066-382e1914a83f	AL Noorain Veg and Fruits\t	504148690/farsana		2025-06-25 11:34:21.473	2025-06-25 11:34:21.473				
be56b68c-436f-414d-8b29-f81e23ae6afa	Crowds Restaurant\t			2025-06-26 06:22:49.379	2025-06-26 06:22:49.379		\tCN-4761135		
31d5cf78-1522-4e73-ae3b-ff7ac851ea6e	Tierra Café \t	52 763 2334-farsana		2025-06-25 11:35:05.823	2025-06-25 11:35:05.823				
1855dbbf-0c07-48ad-a7ab-57dd10d078ee	Tierra Café \t	52 763 2334-farsana		2025-06-25 11:35:19.861	2025-06-25 11:35:19.861				
99d205ad-3395-4e3b-911c-ce325649d867	Tierra Café \t	52 763 2334-farsana		2025-06-25 11:36:10.292	2025-06-25 11:36:10.292				
90913328-5c82-4334-bc4c-d004fac1ccc0	Tierra Café \t	52 763 2334-farsana		2025-06-25 11:36:29.633	2025-06-25 11:36:29.633				
dd64d0aa-452b-47e8-827b-7bbd6136c834	Lamars rest and café	971 56 229 2557-farsana		2025-06-25 11:37:07.851	2025-06-25 11:37:07.851				
e04a8f2e-7379-4c03-bf7c-8a05ca1525fa	Lamars rest and café	971 56 229 2557-farsana		2025-06-25 11:37:25.032	2025-06-25 11:37:25.032				
0d7dbf0a-d74c-427b-8b2e-08a9b12834f2	Lamars rest and café	971 56 229 2557-farsana		2025-06-25 11:37:50.52	2025-06-25 11:37:50.52				
e553f317-3c65-4a39-a99a-89cf4c35349d	Lamars rest and café	971 56 229 2557-farsana		2025-06-25 11:38:26.598	2025-06-25 11:38:26.598				
2bc06bef-888a-4593-aa58-35c74cb875dc	Lamars rest and café	971 56 229 2557-farsana		2025-06-25 11:38:43.195	2025-06-25 11:38:43.195				
6ad279d3-e91b-4d62-9a74-4f86a770a26c	Lamars rest and café	971 56 229 2557-farsana		2025-06-25 11:39:03.486	2025-06-25 11:39:03.486				
16fc9581-58fa-4ea1-8f98-25ba1c959dd0	Tierra speciality coffe	52 763 2334-farsana		2025-06-25 11:39:35.359	2025-06-25 11:39:35.359				
5b5107b6-1eb4-47b3-913a-7d974dcf440a	Adnoc Corniche			2025-06-25 11:55:50.966	2025-06-25 11:55:50.966		CN-1031673-3		
1ae0dd04-7a50-4f73-9cfa-180753128981	Officer City 			2025-06-25 11:56:10.025	2025-06-25 11:56:10.025		CN-1031673-57		
a95d5c34-5a07-432a-8218-62d768f5742d	Green House Trading LLC			2025-06-25 12:17:15.232	2025-06-25 12:17:15.232		CN-1040946		
e0bf03aa-38d8-426c-9f2b-7cf61c2d39b1	Green House Trading LLC			2025-06-25 12:18:31.992	2025-06-25 12:18:31.992		CN-1040946		
695ded13-4c6f-49ee-b8b6-ba1e8f34c2c4	Green House Trading LLC			2025-06-25 12:24:33.909	2025-06-25 12:24:33.909		CN-1040946		
8d69ef23-2835-40fb-8fae-f542dc64057e	Green House Trading LLC			2025-06-25 12:25:08.139	2025-06-25 12:25:08.139		CN-1040946		
99fa3ef7-d798-4f36-83ba-74a105c86cf9	Sushi House 			2025-06-25 13:44:52.046	2025-06-25 13:44:52.046				
39511d98-550d-486c-95b6-10b7c008f175	Zad Al Khair Catering \t	 50 847 1618		2025-06-25 13:46:46.416	2025-06-25 13:46:46.416				
e1e5b1c7-15d6-421f-b87f-4d859c04eef7	Zad Al Khair Catering \t	 50 847 1618		2025-06-25 13:46:50.393	2025-06-25 13:46:50.393				
1dcf222c-6965-46b9-bb05-b2fb780f4343	Zad Al Khair Catering \t	 50 847 1618		2025-06-25 13:46:57.109	2025-06-25 13:46:57.109				
7bbbc8f6-9d6f-4c3e-8c2f-a1a3e48d66de	Gotohan ok na to 			2025-06-25 13:47:57.553	2025-06-25 13:47:57.553				
a79636c2-d600-4d74-94cb-c6d9bab805a3	Zad Catering 			2025-06-25 13:48:02.232	2025-06-25 13:48:02.232				
9cc5200d-1680-4f67-981d-d42e8eba7659	Zad Catering 			2025-06-25 13:48:24.157	2025-06-25 13:48:24.157				
9d28d422-ca43-4ade-85eb-89bca10c0bec	Zad Al Khair Catering \t			2025-06-25 13:48:59.04	2025-06-25 13:48:59.04				
d148ebd8-267e-402f-afb2-1624e0b101dc	Zad Catering 			2025-06-25 13:49:05.592	2025-06-25 13:49:05.592				
706edbf7-e186-4399-819e-a1580c70df3b	Zad Catering 			2025-06-25 13:49:08.885	2025-06-25 13:49:08.885				
3b5859e5-cefb-4a9d-a089-fe177673edb1	Ared Alshawarma Cafeteria 			2025-06-25 13:52:25.617	2025-06-25 13:52:25.617		CN-3741102		
fd9911d4-e7df-4984-becb-e53df689c751	Miss J Cafe\t			2025-06-25 13:52:44.723	2025-06-25 13:52:44.723		CN-1039849-1		
9c4c3605-f93e-412e-916a-11fbcc432505	Deep Café & Roastery \t	 55 512 0904		2025-06-25 13:53:07.567	2025-06-25 13:53:07.567				
394abdca-4c97-4597-87cb-23d0617a22c4	Jory catering Service\t			2025-06-25 13:54:21.187	2025-06-25 13:54:21.187		CN-2759203		
21327b60-8409-4726-9557-b86039ff9404	Al Sultan Markets & Bakeries\t			2025-06-25 13:54:33.978	2025-06-25 13:54:33.978				
3652c97b-b456-48f2-8d84-078e2ec76b24	Al Sultan Markets & Bakeries\t			2025-06-25 13:54:41.368	2025-06-25 13:54:41.368				
e3ba1180-41fd-4352-b1a6-8f07cb70c727	Al Sultan Markets & Bakeries\t			2025-06-25 13:54:50.378	2025-06-25 13:54:50.378				
75131cc9-bec1-4748-ba59-2d182c620aad	Al Sultan Markets & Bakeries\t			2025-06-25 13:54:58.078	2025-06-25 13:54:58.078				
9f984213-f7a3-461d-9576-be4d175df21d	Al Sultan Markets & Bakeries\t			2025-06-25 13:55:05.116	2025-06-25 13:55:05.116				
a3335989-9a54-41c4-972f-e025fa4c1056	Al Sultan Markets & Bakeries\t			2025-06-25 13:55:18.403	2025-06-25 13:55:18.403				
d1abaeb6-1981-4ca9-a856-9e098e15fd3f	Doner Almani Cafeteria\t			2025-06-25 13:55:55.793	2025-06-25 13:55:55.793		CN-5023808		
3f5d487a-e899-413c-9311-85621999eac7	Pizza World \t			2025-06-25 13:56:11.366	2025-06-25 13:56:11.366				
4c43c857-de0f-4d57-8672-af4e2b8fa4b1	Pizza World \t			2025-06-25 13:56:19.981	2025-06-25 13:56:19.981		CN-3750598		
1af25b58-b0e0-4e03-96e4-085e7dea4c79	30 Fruit Juice and Pastries café \t			2025-06-25 13:56:50.113	2025-06-25 13:56:50.113		CN-5771563		
06bdaa0f-a383-410f-a26c-acdea77ccff2	Typing coffee shop\t			2025-06-25 13:57:09.501	2025-06-25 13:57:09.501		CN-3815830		
5c9438df-8ab1-4547-8e47-77fc47851b81	Grandiose Supermarket\t			2025-06-25 13:57:28.746	2025-06-25 13:57:28.746		CN-5517840		
3a95a22e-e1b3-416d-b525-fdaf6a13483c	Burger Stop Cafeteria	50 233 3157		2025-06-25 14:01:05.762	2025-06-25 14:01:05.762		CN-2174527		
959d6877-da57-4dcd-95b1-90f3113ec98e	Burger Stop Cafeteria	0502333157		2025-06-25 14:01:27.369	2025-06-25 14:01:27.369				
fb312a83-7ec4-4864-8701-85edcfa54f73	Burger Stop Cafeteria	0502333157		2025-06-25 14:01:36.343	2025-06-25 14:01:36.343		CN-2174527		
adf026de-92c6-457d-9a2a-bef3bd1220a1	Hinoki restaurant\t			2025-06-25 14:02:13.431	2025-06-25 14:02:13.431				
74a59d71-7e23-4fd3-ba4f-c811a1bc65fb	Hinoki restaurant\t			2025-06-25 14:02:23.897	2025-06-25 14:02:23.897				
ba15904c-efbb-4499-9d00-ba65c6b2d6c7	Hinoki restaurant\t			2025-06-25 14:02:32.272	2025-06-25 14:02:32.272				
83d574ac-c5d3-4e16-8501-9e2e763b635a	Hinoki restaurant\t			2025-06-25 14:02:43.352	2025-06-25 14:02:43.352				
a4cf0dcf-bd6a-4e4a-a364-ec72e4b8c21d	Al Mafizul Haque Restaurant\t			2025-06-25 14:02:56.549	2025-06-25 14:02:56.549				
2e77a46e-278f-4e58-bf9c-bef01d3b6b45	30 Fruit Juice and Pastries café \t			2025-06-25 14:03:18.867	2025-06-25 14:03:18.867		CN-5771563		
0fdf4d32-19a1-4886-a4f7-81e3fa835428	Al Remal Thahabeya Restaurant\t			2025-06-25 14:03:36.139	2025-06-25 14:03:36.139		CN-1105289		
df7575f2-3df4-4a2d-a0ad-00841993c4b8	Adnoc Samha			2025-06-26 04:00:03.232	2025-06-26 04:00:03.232				
4a35c4e1-a7a6-41f7-8093-0c1952de5252	Adnoc Samha			2025-06-26 04:00:46.831	2025-06-26 04:00:46.831				
4329f809-9d31-4276-af8c-93e5c246a07f	Yas Mall			2025-06-26 04:01:35.656	2025-06-26 04:01:35.656				
f834cd07-9b1b-4406-9707-f2313a7b8832	Deerfields Mall			2025-06-26 04:02:49.325	2025-06-26 04:02:49.325				
30adbc57-ceeb-4e1a-9b82-619c541af4d8	Al Saiyah Mussafah			2025-06-26 04:03:29.891	2025-06-26 04:03:29.891				
4636ff2f-a0ab-4446-ae20-a9dd3450377d	Adnoc Khalifa City South			2025-06-26 04:04:38.658	2025-06-26 04:04:38.658				
a03406df-c6df-4f0a-99ce-6513900a829e	Zayed City Al Dhafra			2025-06-26 04:08:11.145	2025-06-26 04:08:11.145				
65a3828c-aab2-49be-8254-327830050daf	Adnoc Shamkha 2			2025-06-26 04:09:25.029	2025-06-26 04:09:25.029				
ebeb6ad6-b607-4625-840b-39dbcb43a9ba	Adnoc Shakhbout			2025-06-26 04:10:11.34	2025-06-26 04:10:11.34				
3f2bef6c-537c-47ba-b145-ff9423d7e933	30 Fruit Juice and Pastries café \t			2025-06-26 04:10:31.771	2025-06-26 04:10:31.771		CN-5771563		
3784a0dd-8dee-46ae-88b2-9b195251c47a	Officer City 			2025-06-26 04:11:21.379	2025-06-26 04:11:21.379				
897f9fa8-499c-4bb8-abf3-1e062839f0b9	Adnoc Tamouh 			2025-06-26 04:14:05.102	2025-06-26 04:14:05.102				
293be435-6357-48b1-8f09-e369d576508f	Burger Stop Cafeteria	50 233 3157		2025-06-26 04:15:09.924	2025-06-26 04:15:09.924		CN-2174527		
165801e9-c25c-4940-8061-50bdc7933482	Burger Stop Cafeteria	0502333157		2025-06-26 04:16:32.314	2025-06-26 04:16:32.314		CN-2174527		
9d945b72-3673-4740-ac06-4fbd6f486480	Gyma  Food Industries 			2025-06-26 04:18:47.045	2025-06-26 04:18:47.045		602302		
02f8ff7a-7cb0-4dce-bc43-cee24ad8ea0c	Doner Almani Cafeteria\t			2025-06-26 04:25:45.079	2025-06-26 04:25:45.079		CN-5023808		
cd0f83d8-c6ca-4447-a452-b38fb01ca15e	Adnoc Khalifa City South			2025-06-26 04:27:03.421	2025-06-26 04:27:03.421		CN-1031673-56		
6cf54fe9-b5b2-4442-954a-7493055cc77d	Officer City 			2025-06-26 04:28:09.22	2025-06-26 04:28:09.22		CN-1031673-57		
ee87e1bc-8c22-4f2a-a24c-e4cb208ff72e	Jory catering Service\t			2025-06-26 04:29:47.979	2025-06-26 04:29:47.979		CN-2759203		
27dd6ff3-6a34-459c-8789-76d481f7c513	Al Saiyah Mussafah			2025-06-26 04:31:02.135	2025-06-26 04:31:02.135		CN-1031673-20		
a89145dd-7d97-40ea-a5fc-1064734acf4c	Adnoc Tamouh 			2025-06-26 04:34:06.453	2025-06-26 04:34:06.453		CN-2779104		
96e1a4bb-b16e-4791-86b8-5e413573556e	Adnoc Shamkha 2			2025-06-26 04:35:14.886	2025-06-26 04:35:14.886		CN-1031673-39		
a9227e8d-1411-45fd-a73e-d6a164012346	Adnoc Shamkha 2			2025-06-26 04:35:27.108	2025-06-26 04:35:27.108		CN-1031673-39		
30850a73-19d6-44f5-95f7-581d85f3dc0e	Adnoc Shakhbout			2025-06-26 04:36:30.224	2025-06-26 04:36:30.224		CN-1031673-45		
bb7c92bb-fd2d-4b6a-9029-c1e97225bd05	Zayed City Al Dhafra			2025-06-26 04:38:07.055	2025-06-26 04:38:07.055		CN-5286776		
c20e6734-2c3b-448b-9861-795009112b95	Al Mafizul Haque Restaurant\t			2025-06-26 04:38:16.977	2025-06-26 04:38:16.977		CN-1116616		
a7ff7a81-d669-43ca-b94a-558c68e923ff	Al Bateen			2025-06-26 04:40:16.828	2025-06-26 04:40:16.828		CN-1031673-14		
db1e33b2-5a41-4444-af4e-ad88412108ba	Al Sultan Markets & Bakeries\t			2025-06-26 04:42:23.877	2025-06-26 04:42:23.877		CN-1111903		
c9f697ce-c8b4-4825-b4ee-4cb07f9ac14c	Al Sultan Markets & Bakeries\t			2025-06-26 04:47:44.557	2025-06-26 04:47:44.557		CN-1111903		
c26ef452-94c1-431b-a01b-a1ebd296bc84	Deep Café & Roastery \t	 55 512 0904		2025-06-26 04:50:53.538	2025-06-26 04:50:53.538		CN-3966962		
e2dca5a8-9207-4a1e-892c-9451dbb50cad	Yas Mall 			2025-06-26 04:55:01.447	2025-06-26 04:55:01.447		CN-1019447-11		
a53745a4-0b93-44da-a3f9-e85205fb7cdf	Al Sultan Markets & Bakeries\t			2025-06-26 04:55:01.866	2025-06-26 04:55:01.866		CN-1111902		
92db1fdc-73c1-4ff0-a074-b69eab125401	Green House Trading LLC			2025-06-26 04:56:21.074	2025-06-26 04:56:21.074		CN-1040946		
127c4da4-c11a-4501-ad54-08e6a221ab0a	Al Sultan Markets & Bakeries\t			2025-06-26 04:57:19.722	2025-06-26 04:57:19.722		CN-1111902		
93934fd6-67dc-4df4-9876-11fae659fdc3	Green House Trading LLC			2025-06-26 04:57:29.85	2025-06-26 04:57:29.85		CN-1040946		
b224dbe3-d56f-4c66-ad43-7ae32c3a0718	Green House Trading LLC			2025-06-26 04:58:22.042	2025-06-26 04:58:22.042		CN-1040946		
49213d11-e1b2-4d9e-9e98-57f92850900f	Al Sultan Markets & Bakeries\t			2025-06-26 05:00:12.22	2025-06-26 05:00:12.22		CN-1111902		
57e8241f-cf1d-411a-95ab-168b2163cc4c	Al Sultan Markets & Bakeries\t			2025-06-26 05:02:33.617	2025-06-26 05:02:33.617		CN-1111902		
d27daced-993f-43f8-8b2e-b1091163724e	Al Azhaar Restaurant and Grilled\t			2025-06-26 05:10:40.198	2025-06-26 05:10:40.198		CN-1114171		
761d2468-f116-4cb8-bb53-bef97ca51840	Deerfields Mall			2025-06-26 05:14:49.027	2025-06-26 05:14:49.027		CN-4823843		
9f52845d-52bf-42f4-9d6b-b28d97c96560	Pizza World \t			2025-06-26 05:15:18.257	2025-06-26 05:15:18.257		CN-3750598		
95ea18a4-0870-4e8e-b182-d65517a5d9d0	Yas Mall			2025-06-26 05:16:21.321	2025-06-26 05:16:21.321		CN-1031673-50		
ce7ae2ce-4b00-482e-a471-aaed03a3d655	Adnoc Samha			2025-06-26 05:17:22.783	2025-06-26 05:17:22.783		CN-5420778		
4f332862-7e05-4351-bc5f-2a952e7e3b04	Adnoc Samha			2025-06-26 05:18:19.607	2025-06-26 05:18:19.607		CN-5420778		
466817dd-ffb1-4ff6-ba93-2e6945ffb72d	Al Remal Thahabeya Restaurant\t			2025-06-26 05:18:56.064	2025-06-26 05:18:56.064		CN-1105289		
465b1a65-079a-4286-b51c-36fe4221b8e1	Adnoc al Bahia 			2025-06-26 05:22:09.358	2025-06-26 05:22:09.358				
6ed2d2e4-d3da-43e0-b008-ff3b09512f48	Adnoc al Bahia 			2025-06-26 05:23:13.783	2025-06-26 05:23:13.783		CN-1031673-50		
43afa73a-0e5e-4fa1-8690-245f3ced8b73	Grandiose Supermarket\t			2025-06-26 05:25:05.04	2025-06-26 05:25:05.04		CN-5517840		
31fcb934-5efd-45c6-ab3b-8806d68fc5c5	Grandiose Supermarket\t			2025-06-26 05:26:46.636	2025-06-26 05:26:46.636		CN-5517840		
b727dc42-1cf0-4a74-9a57-7817f9a7d6bf	Adnoc Samha			2025-06-26 05:27:33.199	2025-06-26 05:27:33.199		CN-1031673-50		
0a1bb772-ee94-435b-abf6-b9435b0cf137	Adnoc Samha			2025-06-26 05:27:42.05	2025-06-26 05:27:42.05		CN-1031673-50		
11b1313e-15c6-42a7-9ee2-819feab853d6	Ared Alshawarma Cafeteria 			2025-06-26 05:30:48.849	2025-06-26 05:30:48.849		CN-3741102		
42ed7e06-5349-4cf3-a15f-b59af9877dcb	Ared Alshawarma Cafeteria 			2025-06-26 05:33:00.03	2025-06-26 05:33:00.03		CN-3741102		
9bcb578c-886b-4c83-b0a3-aea0ab5543ee	Al Mallah Restaurant & Grills	50 233 3157		2025-06-26 05:35:38.974	2025-06-26 05:35:38.974				
e8820251-e46c-4ec2-b39f-91ccae01a752	Miss J Cafe\t			2025-06-26 05:43:48.02	2025-06-26 05:43:48.02		CN-1039849-1		
04f0a6e2-a710-4fcf-853f-680c6f7d2588	Al Mersah Restaurant 			2025-06-26 05:51:42.248	2025-06-26 05:51:42.248				
06b13d60-5b5d-4ed9-a1ea-d85b660c59a7	Miss J Cafe\t			2025-06-26 05:52:04.193	2025-06-26 05:52:04.193		CN-1039849-1		
43d8ca4b-5c09-4ffb-82ff-7a69fa5d45c3	Al Sultan Markets & Bakeries\t			2025-06-26 05:52:43.254	2025-06-26 05:52:43.254		CN-1111903		
7786ad8d-9d92-482a-be44-14529e9503a9	Al Ain Rotana			2025-06-26 05:53:01.53	2025-06-26 05:53:01.53				
212f3d5f-743d-402c-928b-d8cc4dd0860f	Bawabat Al sharq Mall			2025-06-26 05:54:31.346	2025-06-26 05:54:31.346		CN-1031673-24		
a1cf469a-b02e-4d49-863b-4054c91a13a4	Adnoc Embassies Area			2025-06-26 05:56:09.343	2025-06-26 05:56:09.343		CN-1031673-16		
7d5abc5e-e364-4026-877e-aa3aad235e1e	Adnoc Tamouh 			2025-06-26 05:58:49.267	2025-06-26 05:58:49.267		CN-2779104		
2163555d-396f-4c14-8705-d1ee37165d15	Adnoc Tamouh 			2025-06-26 05:59:07.679	2025-06-26 05:59:07.679		CN-2779104		
431ce46f-1c17-4bbf-99ea-3f1c2c8bc371	Bawabat Al sharq Mall			2025-06-26 05:59:37.622	2025-06-26 05:59:37.622		CN-1031673-24		
95b34eb4-7c62-45c4-b187-f760cdbca6a0	Adnoc Shakhbout			2025-06-26 06:01:20.143	2025-06-26 06:01:20.143				
93f1d72b-c00c-49e9-a339-f46e584b56a0	Al Saiyah Mussafah			2025-06-26 06:02:41.562	2025-06-26 06:02:41.562				
e961858e-b5aa-45d8-acf9-aa5b2c0d6c8d	Adnoc Shakhbout			2025-06-26 06:04:29.52	2025-06-26 06:04:29.52				
fc96bf30-d6ac-4a5c-ae95-5464d4d9e53f	Al Bateen			2025-06-26 06:06:48.674	2025-06-26 06:06:48.674		CN-1031673-14		
c90089f7-e8b1-4adf-a707-806524b46d18	Burger Stop Cafeteria	50 233 3157		2025-06-26 06:13:03.395	2025-06-26 06:13:03.395		CN-2174527		
bb35c535-da25-4580-9d64-b9e44967bf8d	Hinoki restaurant\t			2025-06-26 06:19:04.931	2025-06-26 06:19:04.931		CN-4705145		
e3898109-6655-42ff-afe6-9719cbf7b33f	Crowds Restaurant\t			2025-06-26 06:23:25.771	2025-06-26 06:23:25.771		\tCN-4761135		
ce11fc30-aa3b-459b-bb65-c5b24dd942e5	\tSforno Pizza and Pasta   Restaurant \t\t			2025-06-26 06:25:01.235	2025-06-26 06:25:01.235		CN-2933312		
15c87741-ca2c-4147-b979-911bf3a6dee6	Hinoki restaurant\t			2025-06-26 06:26:17.335	2025-06-26 06:26:17.335		\tCN-4705145		
e4765f05-06bb-4485-aaf9-8c96797b5cf8	Ahmed Ali Refreshment 			2025-06-26 06:43:45.815	2025-06-26 06:43:45.815				
6bfa79a9-c137-44a8-9b40-f1ab7f9207a6	Yas Mall 			2025-06-26 07:08:33.612	2025-06-26 07:08:33.612		CN-1019447-11		
2c210235-d4ce-47c1-8fe3-13498e56d490	Green House Trading LLC			2025-06-26 07:21:31.153	2025-06-26 07:21:31.153		CN-1040946		
d0f7448a-3d78-424a-bc23-8d516822b06d	Personal 			2025-06-26 08:52:13.348	2025-06-26 08:52:13.348				
b7c4c960-dd20-4867-b559-94914ae9d837	Adnoc Samha			2025-06-26 08:53:06.693	2025-06-26 08:53:06.693				
febb3e41-5f3a-4976-9908-479add4d96d0	Adnoc Samha			2025-06-26 08:53:29.943	2025-06-26 08:53:29.943				
c9f230b1-e490-4c5f-ad5a-3741914281ea	Yas Mall			2025-06-26 08:54:11.104	2025-06-26 08:54:11.104				
cc5da69b-0b62-4f72-95c5-ce60f536ae4c	Deerfields Mall			2025-06-26 08:54:33.124	2025-06-26 08:54:33.124				
231a1640-08b7-49dd-8a67-ca673e2f2287	Al Saiyah Mussafah			2025-06-26 08:55:03.417	2025-06-26 08:55:03.417				
66e97e51-6743-47d8-99d8-dcd68e464841	Adnoc Khalifa City South			2025-06-26 08:55:32.264	2025-06-26 08:55:32.264				
4404abd3-8125-437f-b191-0fb82e324f01	Zayed City Al Dhafra			2025-06-26 08:55:55.723	2025-06-26 08:55:55.723				
220df695-76e6-4bcc-b9a4-78fb5d5e3544	Zayed City Al Dhafra			2025-06-26 08:56:07.493	2025-06-26 08:56:07.493				
93ac14a8-9a86-4b15-8e96-e56e77727600	Adnoc Shamkha 2			2025-06-26 08:56:24.836	2025-06-26 08:56:24.836				
576eef11-f1df-4e61-a154-e6af57a34fb8	Adnoc Shakhbout			2025-06-26 08:56:44.345	2025-06-26 08:56:44.345				
69bcf53d-f5bc-421a-a0c5-1d9a9bb8062c	Adnoc Shakhbout			2025-06-26 08:56:54.951	2025-06-26 08:56:54.951				
8fa522df-532b-4f6c-9e44-8fcefaf75ad6	Bawabat Al sharq Mall			2025-06-26 08:58:23.445	2025-06-26 08:58:23.445		CN-1031673-24		
91d897a8-a2f6-4a7a-b41f-f842f1d1c96c	Officer City 			2025-06-26 08:58:50.361	2025-06-26 08:58:50.361				
0ae83252-a8bc-426c-b82e-cf1e756808c0	Adnoc Tamouh 			2025-06-26 08:59:09.73	2025-06-26 08:59:09.73				
446f53e1-0bdb-475f-b588-d16d89d6dd36	Al Bateen 			2025-06-26 09:01:57.87	2025-06-26 09:01:57.87		CN-1031673-14		
50a8fc62-4a06-46a5-8fd7-f7aaa8c1ef06	Adnoc Embassies Area			2025-06-26 09:03:01.885	2025-06-26 09:03:01.885				
739a1d7c-6715-42d9-95f8-288a62bb71f6	Adnoc Shamkha 2			2025-06-26 09:04:05.056	2025-06-26 09:04:05.056				
9605097a-9554-42f5-9081-eb49a908cbdb	Adnoc Embassies Area			2025-06-26 09:05:20.908	2025-06-26 09:05:20.908		CN-1031673-16		
ddcc8490-cbb4-4a88-b5ac-8910b4ad83a2	Adnoc Tamouh 			2025-06-26 09:06:21.268	2025-06-26 09:06:21.268		CN-2779104		
b4fd80a0-d186-46b7-9eb0-5b979c84bf44	Adnoc Tamouh 			2025-06-26 09:07:04.036	2025-06-26 09:07:04.036		CN-2779104		
0ee70eef-ae92-461a-ad11-5396c6457945	Deerfields Mall			2025-06-26 09:11:52.547	2025-06-26 09:11:52.547		CN-4823843		
fda6b854-f2a4-4332-a2a8-d291525dd25a	Adnoc Shamkha 2			2025-06-26 09:17:52.07	2025-06-26 09:17:52.07		cn-1031673-39		
ff2c19ba-9500-4569-ad3d-b0246e63256e	Adnoc Shakhbout			2025-06-26 09:24:15.171	2025-06-26 09:24:15.171		CN-1031673-45		
076984b9-5f10-407f-8b1e-41a27050b940	Adnoc Shamkha 2			2025-06-26 09:48:45.968	2025-06-26 09:48:45.968		CN-1031673-39		
f44abb25-2948-4043-be4e-7b91c116cb96	Adnoc Khalifa City South			2025-06-26 10:04:56.02	2025-06-26 10:04:56.02		CN-1031673-56		
86ec50b4-baaf-4439-b30c-68cf62cb7285	Adnoc Khalifa City South			2025-06-26 10:07:06.867	2025-06-26 10:07:06.867		CN-1031673-56		
0da0ac2a-d852-4d9b-8a13-ee0dc68aeaa3	Al Saiyah Mussafah			2025-06-26 10:10:59.989	2025-06-26 10:10:59.989		CN-1031673-20		
5e156c88-cc70-4893-bef7-420f3c52352a	Officer City 			2025-06-26 10:15:07.826	2025-06-26 10:15:07.826		CN-1031673-57		
6771b816-9fb2-4fb3-8243-24982ec89d6e	Yas Mall			2025-06-26 10:27:29.627	2025-06-26 10:27:29.627		CN-1031673-50		
eb463db8-4bb5-48d9-9e5a-b82687e11e29	Zayed City Al Dhafra			2025-06-26 10:34:23.059	2025-06-26 10:34:23.059		CN-5286776		
10c975d4-f918-40fd-b941-bdb6d4e41a7b	Al Saiyah Mussafah			2025-06-26 10:41:32.971	2025-06-26 10:41:32.971		CN-1031673-20		
cb948bc6-adcf-4ef7-a69b-086309301580	Zayed City Al Dhafra			2025-06-26 10:42:00.258	2025-06-26 10:42:00.258		CN-5286776		
e75c74c3-8af3-43ce-8063-72c120e2e6b4	Officer City 			2025-06-26 10:42:10.017	2025-06-26 10:42:10.017		CN-1031673-57		
83142ff6-35cd-43f0-a379-d927c21ddc6d	Adnoc Samha			2025-06-26 10:51:28.34	2025-06-26 10:51:28.34		CN-5420778		
10ef1c49-96fd-4fc4-b613-4adde6852d37	Adnoc Samha			2025-06-26 10:51:37.62	2025-06-26 10:51:37.62		CN-5420778		
cb485065-0e96-412b-a0a6-ce5b89f858ed	Al Sadu Mandi Restaurant			2025-06-26 11:23:12.26	2025-06-26 11:23:12.26		CN-2816246		
e6e1af81-4de0-423e-bba2-dbaeedb31dad	Bangla Baraka Restaurant 	56 118 0750		2025-06-26 11:23:22.087	2025-06-26 11:23:22.087				
269013c7-cd51-419c-8d94-f65ef0bbb6cc	Dar Karak & Muhala Restaurant 			2025-06-28 07:29:12.213	2025-06-28 07:29:12.213		CN-1048363		
abb8a6fe-1ec2-4ce2-87ee-5749b32e56ec	Gulf Queen Bakery 			2025-06-28 07:30:19.17	2025-06-28 07:30:19.17				
d7271497-3df8-4b26-b72d-d353b11d613b	Foodies Kitchen Cafeteria 			2025-06-28 07:35:18.276	2025-06-28 07:35:18.276		CN-5555200		
2cdef597-129d-497d-8a84-bbc283f2d131	Foodies Kitchen Cafeteria 			2025-06-28 07:35:33.575	2025-06-28 07:35:33.575		CN-5555200		
9f44f757-1680-4719-84dd-fb0ec4e810e9	Foodies Kitchen Cafeteria 			2025-06-28 07:36:02.338	2025-06-28 07:36:02.338		CN-5555200		
0213bca4-a3cb-4336-bc33-d816d21ea508	Foodies Kitchen Cafeteria 			2025-06-28 07:36:59.228	2025-06-28 07:36:59.228		CN-5555200		
6fea503a-dbf7-4a3d-8408-5617d62e9d4d	Foodies Kitchen Cafeteria 			2025-06-28 07:37:05.777	2025-06-28 07:37:05.777		CN-5555200		
b555bb51-2c29-4401-ad82-5f117fee6f1c	Foodies Kitchen Cafeteria 			2025-06-28 07:37:12.81	2025-06-28 07:37:12.81		CN-5555200		
da6669ba-6a8f-4fb0-aed8-f6f94866bedb	Danat Al Ain Resort \t			2025-06-28 08:11:25.666	2025-06-28 08:11:25.666		CN-2241858		
619cf920-0ca2-42df-90a1-711038eb1054	Danat Al Ain Resort \t			2025-06-28 08:12:12.156	2025-06-28 08:12:12.156		CN-2241858		
08b3e005-284f-431c-ad85-0f827f632d33	Coriander Restaurant \t			2025-06-28 08:12:41.792	2025-06-28 08:12:41.792		CN-1173121		
c9d3f72b-4bef-405f-ae36-9d8b5abc5a34	Coriander Restaurant \t			2025-06-28 08:12:55.231	2025-06-28 08:12:55.231		CN-1173121		
93299304-3f32-4bc9-8d91-380aa665ee98	Coriander Restaurant \t			2025-06-28 08:12:59.583	2025-06-28 08:12:59.583		CN-1173121		
81b19b58-edef-4269-823a-31c062e63ec0	Delicacy Vita Flowers and Sweets\t			2025-06-28 08:13:20.65	2025-06-28 08:13:20.65		CN-5611228		
fcfd59d3-193d-42d0-a73b-9a8b46e3d0cd	SKW Café \t			2025-06-28 08:13:47.249	2025-06-28 08:13:47.249		CN-4588008		
98015c75-40af-4394-af61-9eb871ae0f7f	Mang Philip Restaurant \t			2025-06-28 08:14:10.101	2025-06-28 08:14:10.101		502993470    		
cf04eeed-d743-4520-a91e-683bbc819a18	Mang Philip Restaurant \t			2025-06-28 08:14:33.673	2025-06-28 08:14:33.673		CN-3881788		
98e7d3f8-06d8-4f98-8126-20a0cdf37aa4	Tru Boutique Café \t			2025-06-28 08:14:55.76	2025-06-28 08:14:55.76		CN-3899584		
071ce42f-36e2-4cdb-af41-c7087315c138	Cafeteria Juice Spot\t			2025-06-28 08:15:21.929	2025-06-28 08:15:21.929				
3c1f9171-e2b3-4c9a-a565-3e7867e65dc0	Cafeteria Juice Spot\t			2025-06-28 08:15:30.266	2025-06-28 08:15:30.266				
5e672ad9-6abe-4e62-941a-d49de7ab1310	\tfelicita boutique \t	54 204 4493		2025-06-28 08:16:30.34	2025-06-28 08:16:30.34				
71d8067d-c0a2-45d9-beaa-90880e41dbc4	Felicita Boutique For  Flowers\t	54 204 4493		2025-06-28 08:17:41.512	2025-06-28 08:17:41.512		CN-4514593		
8c151a2a-781f-4fac-b80d-754e2ee7cc3e	Cafeteria Juice Spot\t			2025-06-28 08:18:57.824	2025-06-28 08:18:57.824		CN-3821596		
87ad0658-1f30-4529-b232-833049ec322e	Cafeteria Juice Spot\t			2025-06-28 08:19:01.842	2025-06-28 08:19:01.842		CN-3821596		
d9ad4e43-85dc-43bd-aa4f-fdfb7eb157fd	Abu saood Trading Establishment			2025-06-28 08:50:27.993	2025-06-28 08:50:27.993		CN-		
99f5fa2a-4635-42b7-88e6-4ac2db962d38	Abu saood Trading Establishment			2025-06-28 08:51:56.153	2025-06-28 08:51:56.153		CN-1036625		
d9324ca1-470c-4d88-ab34-9c08becba63a	Abu saood Trading Establishment			2025-06-28 08:52:27.448	2025-06-28 08:52:27.448		CN-1036625		
2c413512-133e-41d9-ad29-4f79c886be4f	Abu saood Trading Establishment			2025-06-28 08:52:32.686	2025-06-28 08:52:32.686		CN-1036625		
54db2ae0-ba93-453c-806c-960d849d5b24	Abu saood Trading Establishment			2025-06-28 08:52:37.731	2025-06-28 08:52:37.731		CN-1036625		
ff9a742e-d734-4eeb-820d-bce66e36c9f5	Abu saood Trading Establishment			2025-06-28 08:53:08.951	2025-06-28 08:53:08.951		CN-1036625		
91a4a93a-d1a9-444d-9703-f8b9f01b65a7	Abu saood Trading Establishment			2025-06-28 08:53:52.028	2025-06-28 08:53:52.028		CN-1036625		
b7d07141-0b10-43c1-ac21-c34a0f8d7dca	Abu saood Trading Establishment			2025-06-28 08:54:03.419	2025-06-28 08:54:03.419		CN-1036625		
92307ac3-c48a-4800-88e1-6a5759eb0406	Abu saood Trading Establishment			2025-06-28 08:54:30.135	2025-06-28 08:54:30.135		CN-1036625		
19616993-c2b7-4a80-a6b5-f08988fe17fe	Break Time  Cafeteria 			2025-06-28 09:11:27.027	2025-06-28 09:11:27.027		CN-1481871		
ddec4d66-fd64-4591-aa69-ad6a7e35279a	Abu saood Trading Establishment			2025-06-28 09:11:47.31	2025-06-28 09:11:47.31		CN-1036625		
55f5997e-83de-40ab-a24d-2326d85600eb	Break Time  Cafeteria 			2025-06-28 09:12:04.732	2025-06-28 09:12:04.732		CN-1481871		
f5e9c32d-6904-47c1-a2d5-4c3c7833c64e	Break Time  Cafeteria 			2025-06-28 09:12:46.797	2025-06-28 09:12:46.797		CN-1481871		
6b9043f6-3cf3-4c76-8ae2-7322a916fa71	Break Time  Cafeteria 			2025-06-28 09:14:59.672	2025-06-28 09:14:59.672		CN-1481871		
502f7b19-763a-4f84-a01c-b042fc90ed26	Break Time  Cafeteria 			2025-06-28 09:15:08.022	2025-06-28 09:15:08.022		CN-1481871		
4baca501-a644-4513-b73c-3b79e758a0cc	Break Time  Cafeteria 			2025-06-28 09:15:27.123	2025-06-28 09:15:27.123		CN-1481871		
4db042c2-9f54-446c-a0e6-a5b97025d240	Break Time  Cafeteria 			2025-06-28 09:15:32.057	2025-06-28 09:15:32.057		CN-1481871		
cf76c769-bfe9-4c76-8c14-4dda9d1779a0	Break Time  Cafeteria 			2025-06-28 09:15:46.95	2025-06-28 09:15:46.95		CN-1481871		
b8b84f9e-5619-4695-aa27-b7df37e629ba	Break Time  Cafeteria 			2025-06-28 09:20:54.366	2025-06-28 09:20:54.366		CN-1481871		
d92e5cfb-205d-49d2-81fe-822b342925c1	Air Fresh  Baqala 			2025-06-28 09:22:15.988	2025-06-28 09:22:15.988				
b7fcc84e-4c0e-49fa-9a3b-5cf1545dfd6c	Pinoy Grocery 			2025-06-28 09:22:47.13	2025-06-28 09:22:47.13				
25128139-c262-4048-8269-98d2afdbbbf6	Pinoy Grocery 			2025-06-28 09:23:00.348	2025-06-28 09:23:00.348				
e3bdec1c-9995-4b76-9c2e-60b2424660b7	Abm Baqala 			2025-06-28 09:23:29.982	2025-06-28 09:23:29.982				
734fab9c-27c2-45d6-8de2-f498b958fda3	Abm Baqala 			2025-06-28 09:23:37.345	2025-06-28 09:23:37.345				
53d7780a-dc87-46cc-a0a5-988ada92f6f3	Abm Baqala 			2025-06-28 09:23:50.434	2025-06-28 09:23:50.434				
8bb0ee6c-d335-49d1-8763-81f0f7c86e7b	Abm Baqala 			2025-06-28 09:23:57.185	2025-06-28 09:23:57.185				
7f5805db-1f9e-4ed0-bc4a-82ff4d7959a5	Abm Baqala 			2025-06-28 09:24:11.766	2025-06-28 09:24:11.766				
e146ccab-069b-4d4b-98ae-5ae4d8ce7fe6	Abm Baqala 			2025-06-28 09:24:25.857	2025-06-28 09:24:25.857				
90175312-43b5-4273-a7fb-20d9a3a627f5	Air Fresh  Baqala 			2025-06-28 09:29:36.92	2025-06-28 09:29:36.92		CN-2715104		
e0b877e4-ce5f-4a5a-af97-79cd6ce84c07	Pinoy Grocery 			2025-06-28 09:31:04.729	2025-06-28 09:31:04.729		CN-1026891		
bebd140d-eb41-4dd0-9f6b-0ced14676e16	Bin Saleem Grocery 			2025-06-28 09:47:57.206	2025-06-28 09:47:57.206				
3d825958-3328-45dd-85e2-85abf2daa0d2	Bin Saleem Grocery 			2025-06-28 09:49:42.052	2025-06-28 09:49:42.052				
b59f20a1-06aa-4eb2-8d77-cd929d8fcb45	Ahmed Ali Refreshment 	0507422716		2025-06-28 09:55:33.631	2025-06-28 09:55:33.631				
cb5b469b-025a-47de-b647-c1e3d50317ef	Ahmed Ali Refreshment 	0507422716		2025-06-28 09:55:44.228	2025-06-28 09:55:44.228				
8a0dc136-67e8-4c15-ad44-471098cbe7f1	On the Block Cafe			2025-06-28 10:02:26.523	2025-06-28 10:02:26.523		CN-5825141		
b46df61a-3667-4d8e-a278-df9debb310e1	Tierra Cafe			2025-06-28 10:05:45.236	2025-06-28 10:05:45.236				
a9174d74-037f-4468-b4d9-5e2300f5e8e3	Tierra Cafe			2025-06-28 10:05:56.966	2025-06-28 10:05:56.966				
07c7d1de-525c-4b2c-b95b-ac27950552aa	Tierra Cafe			2025-06-28 10:06:10.462	2025-06-28 10:06:10.462				
1f4d1927-969a-470b-af44-0a459d5dc80d	Tierra Cafe 			2025-06-28 10:06:30.359	2025-06-28 10:06:30.359				
55b87cff-dded-41d1-ab27-0d607e63cbc9	Tierra Cafe			2025-06-28 10:06:49.944	2025-06-28 10:06:49.944				
9505d046-6cf2-46ee-aef3-abe36abed858	Tierra Cafe			2025-06-28 10:07:03.828	2025-06-28 10:07:03.828				
5a60db37-d642-48a4-b01c-276b0303c436	Tierra Cafe			2025-06-28 10:07:20.08	2025-06-28 10:07:20.08				
e9ceb527-25d9-4950-8073-29cc75247d63	Tierra Cafe			2025-06-28 10:07:35.6	2025-06-28 10:07:35.6				
480fcb0c-7453-4fe1-b188-804ef02466a9	Lamars rest and café			2025-06-28 10:09:04.358	2025-06-28 10:09:04.358				
ff669c0d-f039-4cf7-9a7d-0453e772747d	Lamars rest and café			2025-06-28 10:09:24.916	2025-06-28 10:09:24.916				
e2759b94-27ac-4483-9dca-2ec536565886	rotana			2025-06-28 10:10:00.747	2025-06-28 10:10:00.747				
74e773b8-a8ad-4ced-b7ad-99114f2a533c	Delicacy Vita Flowers and Sweets\t			2025-06-28 10:10:42.502	2025-06-28 10:10:42.502		CN-5611228		
37d992b6-fd98-4fd5-a4e7-d68fc0aa2d37	Golden Dalla Meals			2025-06-28 10:11:22.71	2025-06-28 10:11:22.71		CN-1530789		
794d031f-a7f4-4cd4-b376-1243c36d236d	Golden Dalla Meals			2025-06-28 10:11:30.23	2025-06-28 10:11:30.23		CN-1530789		
fb14de2c-c26e-483f-b511-d6dd2c2510c0	Lamars rest and café			2025-06-28 10:11:42.29	2025-06-28 10:11:42.29				
b7e45dbc-5379-40b1-8de6-afdeca18a6fa	Golden Dalla Meals			2025-06-28 10:11:47.876	2025-06-28 10:11:47.876		CN-1530789		
ef1eaaf0-c138-4b44-a32f-1e85be04fa90	Lamars rest and café			2025-06-28 10:11:52.624	2025-06-28 10:11:52.624				
2a51b84c-95fe-4b6c-a21e-275d4fe40566	Golden Dalla Meals			2025-06-28 10:11:54.046	2025-06-28 10:11:54.046		CN-1530789		
631e2f03-44f9-4f72-aa61-65a10bce2ab4	Golden Dalla Meals			2025-06-28 10:12:10.603	2025-06-28 10:12:10.603		CN-1530789		
d834f725-89e3-4b4f-99a9-7284072cb448	Tierra Café \t			2025-06-28 10:12:23.078	2025-06-28 10:12:23.078				
e2127ae0-e7c2-41fa-a2d1-854e13910f6d	Golden Dalla Meals			2025-06-28 10:12:24.088	2025-06-28 10:12:24.088		CN-1530789		
387b7c88-3865-41fd-9d84-0073c6e82fe1	Golden Dalla Meals			2025-06-28 10:12:33.453	2025-06-28 10:12:33.453		CN-1530789		
83ac960d-0078-4371-8c54-b71f9fb1d7f3	Golden Dalla Meals			2025-06-28 10:12:54.958	2025-06-28 10:12:54.958		CN-1530789		
1f9bdfa8-47c4-49f7-a4bd-042ffc590ca7	Golden Dalla Meals			2025-06-28 10:13:03.653	2025-06-28 10:13:03.653		CN-1530789		
d2a32ebc-c212-4f25-95bc-8117a59452fa	Tierra Café \t	52 763 2334-farsana		2025-06-28 10:13:19.994	2025-06-28 10:13:19.994				
b642953a-d1ec-4796-8d1e-7c68e88f5e1f	Tierra Café \t			2025-06-28 10:13:49.336	2025-06-28 10:13:49.336				
c9161ae3-d3e3-4fea-bd37-91af646b7399	Tierra Café \t			2025-06-28 10:14:00.336	2025-06-28 10:14:00.336		CN-4409924		
9df7620d-f688-40c1-8322-931c6e0875fe	Silver Baqala 			2025-06-28 10:14:58.6	2025-06-28 10:14:58.6				
ff892b3c-18b5-4496-808a-e489e947ef70	Silver Baqala 			2025-06-28 10:15:05.138	2025-06-28 10:15:05.138				
1997e955-3774-441d-9761-faff1d9bb3dc	Fresh Samawar Restaurant and Cafe 			2025-06-28 10:18:24.329	2025-06-28 10:18:24.329		CN-5210177		
56090d7b-1a78-4766-ba7f-f212d3013539	Chicken Street			2025-06-28 10:46:09.855	2025-06-28 10:46:09.855				
10855d02-d1ee-4796-a42b-8217bbdb6b3f	Chicken Street			2025-06-28 10:46:41.579	2025-06-28 10:46:41.579				
a96a05ec-7a51-4632-aac8-41b2c6f5bdaf	Ali Ahmed Refreshment 			2025-06-28 11:24:54.66	2025-06-28 11:24:54.66				
05373cec-72a5-45ce-a099-803ac914c397	Ali Ahmed Refreshment 			2025-06-28 11:25:02.668	2025-06-28 11:25:02.668				
592bf887-12c6-4d3e-98db-e7791ed8991b	Grandmas Grill and Biryani Restaurant 			2025-06-28 11:31:24.724	2025-06-28 11:31:24.724		CN-3681094		
d38d2d73-4dfe-4a42-a3cb-374c4796b80e	Grandmas Grill and Biryani Restaurant 			2025-06-28 11:32:53.368	2025-06-28 11:32:53.368		CN-3681094		
d7b59ed3-2948-4ccc-88b6-286b0c042262	Grandmas Grill and Biryani Restaurant 			2025-06-28 11:33:17.364	2025-06-28 11:33:17.364		CN-3681094		
7f600115-b596-4986-911e-bb54642be421	Grandmas Grill and Biryani Restaurant 			2025-06-28 11:33:26.247	2025-06-28 11:33:26.247		CN-3681094		
bb23ec2d-6308-4584-94ce-584bca982478	Foodies Kitchen Cafeteria 			2025-06-28 11:33:50.991	2025-06-28 11:33:50.991		CN-5555200		
8c3b4720-65e4-418f-bbcc-047d3b72d9d9	Pearl Rotana 			2025-06-30 03:59:36.097	2025-06-30 03:59:36.097				
0cbb180b-87d3-4fd0-8532-0f950bc88328	Pearl Rotana 			2025-06-30 03:59:53.168	2025-06-30 03:59:53.168				
c9e2e211-979a-4e9f-841f-7afaa5d684be	Pearl Rotana 			2025-06-30 04:00:07.509	2025-06-30 04:00:07.509				
14079640-8b7c-4755-88be-690f5b53fd55	Pear			2025-06-30 04:00:21.819	2025-06-30 04:00:21.819				
702f34d7-3a22-4398-a86d-7490be52ba61	Pearl Rotana 			2025-06-30 04:00:31.71	2025-06-30 04:00:31.71				
5b0d08df-e02c-43b3-9e83-2d449176978e	Pearl Rotana 			2025-06-30 04:00:51.086	2025-06-30 04:00:51.086				
c89bef86-4a31-44e8-a9bb-e0a479e6e3a7	Al Barjeel Restaurant\t	502993470    		2025-06-30 04:11:27.221	2025-06-30 04:11:27.221		CN-1126612		
2f125bf6-86e4-4a37-914c-4fc789bf81a3	Al Barjeel Restaurant\t	502993470    		2025-06-30 04:13:24.794	2025-06-30 04:13:24.794		CN-1126612		
af74918c-23f3-4763-9a29-cd9d07a45d91	Mang Philip Restaurant \t			2025-06-30 04:16:02.652	2025-06-30 04:16:02.652		CN-3881788		
cdf35b6e-7554-41e7-8302-c077d665590a	Pearl Rotana 			2025-06-30 04:18:03.512	2025-06-30 04:18:03.512		CN-2305023		
bd938647-41aa-429d-8c64-0d1cf2906127	Pearl Rotana 			2025-06-30 04:18:08.493	2025-06-30 04:18:08.493		CN-2305023		
d412f4ec-4c10-45cb-bb71-6f9f0fae9896	Pearl Rotana 			2025-06-30 04:18:13.782	2025-06-30 04:18:13.782		CN-2305023		
0b3e77d6-03e7-4d67-9d87-c3e5f4530d49	Pearl Rotana 			2025-06-30 04:18:18.663	2025-06-30 04:18:18.663		CN-2305023		
edc73a0e-7955-4e31-8e12-7da38f3d1a7f	Pearl Rotana 			2025-06-30 04:18:23.939	2025-06-30 04:18:23.939		CN-2305023		
402b28bc-05f7-45e8-b7ae-7ebcf5c2fccf	Coriander Restaurant \t			2025-06-30 04:21:00.289	2025-06-30 04:21:00.289		CN-1173121		
56c122e2-1c37-419e-8445-5691c2ea0490	Coriander Restaurant \t			2025-06-30 04:23:19.848	2025-06-30 04:23:19.848		CN-1173121		
d7ec7e0b-75c8-4596-a80a-7b95cd249613	Al Rawda Arjaan 			2025-06-30 04:24:45.301	2025-06-30 04:24:45.301				
cba8c815-46dc-4af9-bfd6-dde1e930130b	Al Rawda Arjaan 			2025-06-30 04:25:37.56	2025-06-30 04:25:37.56				
3e82bd2d-d5ce-4e00-a4e2-e8c7d6fd3bda	Al Rawda Arjaan 			2025-06-30 04:25:43.62	2025-06-30 04:25:43.62				
226d1da5-d861-45e7-94fd-e028db0d96b0	Khalidiya Palace Rayhaan			2025-06-30 04:26:45.534	2025-06-30 04:26:45.534				
865a3330-c7e5-4a7a-a729-1076a9cb74a7	Pearl Rotana 			2025-06-30 04:28:58.277	2025-06-30 04:28:58.277		CN-2305023		
64b1ebb4-5ab0-4437-a18d-fa1ae4e49d65	Pearl Rotana 			2025-06-30 04:29:08.754	2025-06-30 04:29:08.754		CN-2305023		
8f01d0eb-a5e7-4c94-81bf-738bd1b2746d	Pearl Rotana 			2025-06-30 04:30:31.989	2025-06-30 04:30:31.989		CN-2305023		
6a9a0480-a054-42a2-aa11-1a41e7d1ae03	Delicacy Vita Flowers and Sweets\t			2025-06-30 04:31:18.348	2025-06-30 04:31:18.348		CN-5611228		
4f2cf3e3-68d4-44fb-98c9-c0cc21c0ff89	Pearl Rotana 			2025-06-30 04:31:23.018	2025-06-30 04:31:23.018		CN-2305023		
ea352736-07b6-4c1b-ba01-8183f9e57ee4	Pearl Rotana 			2025-06-30 04:32:55.856	2025-06-30 04:32:55.856		CN-2305023		
c406b384-cf9f-4cfe-a56e-fe3b74e0fffc	On the Block Cafe			2025-06-30 04:40:35.59	2025-06-30 04:40:35.59		CN-5825141		
4e0e0eea-5885-4919-ae57-b36c9e6223a4	Novotel 			2025-06-30 04:42:48.139	2025-06-30 04:42:48.139		CN-2243404		
51fbfbd2-25e2-4afd-8c78-deae3ecb742f	On the Block Cafe			2025-06-30 04:43:32.909	2025-06-30 04:43:32.909		CN-5825141		
df744b1b-2cb3-4dac-b2ce-de04f86be6da	Al Barjeel Restaurant\t			2025-06-30 04:46:02.044	2025-06-30 04:46:02.044		CN-1126612		
0d5bd195-54bc-4a19-984d-eab3d887f094	Danat Al Ain Resort \t			2025-06-30 04:50:34.308	2025-06-30 04:50:34.308		CN-2241858		
c585641e-c896-45a5-942c-9f368be8cd13	Bedashing Beauty Lounge			2025-06-30 04:53:06.786	2025-06-30 04:53:06.786		CN-1147789		
60bcee99-6d68-4da9-9387-4604aa800c38	Al Rawda Arjaan 			2025-06-30 04:54:02.502	2025-06-30 04:54:02.502				
4b1b0e5b-1f04-4ba7-bfed-43376c75ead9	Danat Al Ain Resort \t			2025-06-30 04:54:49.615	2025-06-30 04:54:49.615		CN-2241858		
d79c2438-776f-40a1-8d80-b73bbabde62b	Al Rawda Arjaan 			2025-06-30 04:55:15.899	2025-06-30 04:55:15.899				
fb5b3690-55a5-4d4f-9478-b58ec7348aaa	Centro Al Manhal Hotel			2025-06-30 04:57:14.691	2025-06-30 04:57:14.691				
07390453-a8fe-4d02-b1b6-d70ef0c506f4	Khalidiya Palace Rayhaan			2025-06-30 04:58:29.931	2025-06-30 04:58:29.931		CN-2240612		
7d55c72c-d134-48bc-a540-3884435f6373	Coriander Restaurant \t			2025-06-30 04:59:37.54	2025-06-30 04:59:37.54		CN-1173121		
087ed0d7-2a3a-449e-854d-b618091b6171	Coriander Restaurant \t			2025-06-30 05:00:11.511	2025-06-30 05:00:11.511		CN-1173121		
b18827dc-9f7d-4962-a576-944aeac81de2	Centro Al Manhal Hotel			2025-06-30 05:00:25.348	2025-06-30 05:00:25.348		CN-2242078		
34d6e526-c570-4274-a92d-23ccce2e0c98	Al Rawda Arjaan 			2025-06-30 05:01:03.827	2025-06-30 05:01:03.827		CN-2241148		
234c5281-a05b-40fd-bc28-26bcaf2001fd	.			2025-06-30 05:01:09.499	2025-06-30 05:01:09.499				
94a94f8f-c1b7-483a-91ce-1dfc3b7779e4	.			2025-06-30 05:01:19.724	2025-06-30 05:01:19.724				
5f433ee5-dae0-46c1-a018-9fd068b13c53	Grandmas Grill and Biryani Restaurant 			2025-06-30 05:02:18.162	2025-06-30 05:02:18.162		CN-3681094		
c0ff897d-3ae6-4b4d-b7f6-717f1a732fec	Grandmas Grill and Biryani Restaurant 			2025-06-30 05:02:34.006	2025-06-30 05:02:34.006		CN-3681094		
619d13d0-7b89-4c42-8ee0-8bc7f8aa2ac8	Al Barjeel Restaurant\t			2025-06-30 05:03:25.459	2025-06-30 05:03:25.459				
269d7f01-ca95-4c71-be3a-397f85eb4919	Mang Philip Restaurant \t			2025-06-30 05:03:55.589	2025-06-30 05:03:55.589		CN-3881788		
78e9d296-36de-4dc4-9c56-63f690c68824	Grandmas Grill and Biryani Restaurant 			2025-06-30 05:06:16.093	2025-06-30 05:06:16.093		CN-3681094		
2cc08684-9f28-41c1-abc1-d58adcab4b4d	Grandmas Grill and Biryani Restaurant 			2025-06-30 05:07:01.828	2025-06-30 05:07:01.828		CN-3681094		
6a93d860-a434-444b-896c-a6ddcf57cb14	Grandmas Grill and Biryani Restaurant 			2025-06-30 05:07:08.778	2025-06-30 05:07:08.778		CN-3681094		
a26a7eea-03e8-497a-a0a8-54afb6a18926	Pearl Rotana 			2025-06-30 05:25:26.709	2025-06-30 05:25:26.709		CN-2305023		
cf6b39bc-68e7-42ff-a0fc-5189b2db3bef	Grandmas Grill and Biryani Restaurant 			2025-06-30 05:08:44.637	2025-06-30 05:08:44.637		CN-3681094		
f8b96f5e-5b32-4d83-9909-5b137b81df10	Grandmas Grill and Biryani Restaurant 			2025-06-30 05:08:52.989	2025-06-30 05:08:52.989		CN-3681094		
c23a1410-8985-4bd0-90db-76904546b67a	Pearl Rotana 			2025-06-30 05:10:33.579	2025-06-30 05:10:33.579		CN-2305023		
54c1a951-3dc6-42ad-aa48-1321f126834d	Dar Karak & Muhala Restaurant 			2025-06-30 05:12:39.372	2025-06-30 05:12:39.372				
c35f72ed-9616-48bd-9c49-faf913706083	Bedashing Beauty Lounge			2025-06-30 05:15:01.949	2025-06-30 05:15:01.949		CN-1147789		
3904d036-fede-46e9-bac1-272271f36a94	By Oz Restaurant			2025-06-30 05:15:59.526	2025-06-30 05:15:59.526		CN-4613496		
448e587b-b2e3-44c9-a245-c5b331832c5f	Bedashing Beauty Lounge			2025-06-30 05:16:05.85	2025-06-30 05:16:05.85				
c18995b2-3152-4d9e-ba1a-85202bb28656	Dar Karak & Muhala Restaurant 			2025-06-30 05:16:13.424	2025-06-30 05:16:13.424				
e44f7856-3a51-4553-ae07-a35769b195ba	Bedashing Beauty Lounge			2025-06-30 05:16:21.902	2025-06-30 05:16:21.902		CN-1147789		
ba4935d6-11b0-48b5-9aab-b32946c8183d	Bedashing Beauty Lounge			2025-06-30 05:16:29.949	2025-06-30 05:16:29.949		CN-1147789		
544c26a1-3828-4327-b2d5-3f07319cddf9	Bedashing Beauty Lounge			2025-06-30 05:16:40.084	2025-06-30 05:16:40.084		CN-1147789		
64cc6491-5db4-49a3-bcea-a27c1276c21d	Gulf Queen Bakery 			2025-06-30 05:18:16.086	2025-06-30 05:18:16.086		CN-1019052		
7a6878cf-6928-4cda-aa80-aa76738ea6a3	Khalidiya Palace Rayhaan			2025-06-30 05:42:25.637	2025-06-30 05:42:25.637		CN-2240612		
a7e63f29-f0f8-4270-8453-1cd35a695d12	SKW Café \t			2025-06-30 05:44:14.655	2025-06-30 05:44:14.655		CN-4588008		
c9a766ff-0edb-456c-920b-cb0ccb398d43	Blossom Hotpot Restaurant 			2025-06-30 05:51:29.7	2025-06-30 05:51:29.7		CN-4977227		
77a34d45-1657-4575-bf0a-1f652e386952	Blossom Hotpot Restaurant 			2025-06-30 06:00:45.468	2025-06-30 06:00:45.468		CN-4977227		
c097d83d-6dbe-4a4b-b59b-0af69b604af2	Blossom Hotpot Restaurant 			2025-06-30 06:00:53.672	2025-06-30 06:00:53.672		CN-4977227		
28f8c777-9792-48ec-9e6c-f432a2d45d11	Mang Philip Restaurant \t			2025-06-30 06:01:46.938	2025-06-30 06:01:46.938		CN-3881788		
4f45e384-51b9-412a-a134-4cf0055373d0	Centro Al Manhal Hotel			2025-06-30 06:02:24.698	2025-06-30 06:02:24.698		CN-2242078		
659f7840-9cb4-4322-8c56-469ca1f48258	Pearl Rotana 			2025-06-30 06:03:21.701	2025-06-30 06:03:21.701				
606702a7-44e0-4bfc-8789-ccf27f67e733	Pearl Rotana 			2025-06-30 06:03:30.238	2025-06-30 06:03:30.238		CN-2242078		
fb2fcd34-3060-4818-9488-30b53fa2b201	Pearl Rotana 			2025-06-30 06:03:35.866	2025-06-30 06:03:35.866		CN-2242078		
a20b73d2-9056-4d6b-84a8-45905d9f0bd6	By Oz Restaurant			2025-06-30 06:13:36.943	2025-06-30 06:13:36.943		CN-4613496		
d523ae46-c508-4183-8977-0f12fe334f56	Al Sadu Mandi Restaurant			2025-06-30 06:14:59.204	2025-06-30 06:14:59.204		CN-2816246		
97f2b48c-1214-4726-8866-b5016daa3b38	Hinoki Restaurant			2025-06-30 06:15:41.79	2025-06-30 06:15:41.79		CN-4705145		
536aacf3-a7f6-42ee-b77b-352d0b9cf1ed	Hinoki Restaurant			2025-06-30 06:15:45.892	2025-06-30 06:15:45.892		CN-4705145		
72f858de-5531-42ed-9de4-7a7db1fd8851	Al Remal Thahabeya Restaurant\t	50 731 3327		2025-06-30 06:16:57.856	2025-06-30 06:16:57.856		CN-1105289		
73f90e5a-6472-4ce9-8374-b28b532df6b1	Harees reataurant	50 909 3676		2025-06-30 06:27:14.923	2025-06-30 06:27:14.923				
fd74463b-12e8-4d72-971a-7395abfcd178	Al Mersah Restaurant			2025-06-30 06:37:36.412	2025-06-30 06:37:36.412		CN-1019322		
5df704de-cc75-42a9-9709-7d0d6c37961d	Al Mersah Restaurant			2025-06-30 06:38:26.642	2025-06-30 06:38:26.642				
6a5c5442-eef9-49ef-9fdb-25a88a394864	Al Mersah Restaurant			2025-06-30 06:38:54.525	2025-06-30 06:38:54.525				
ebfb8fd1-a69b-489b-ae6e-4e84f33ee0f5	Al Mersah Restaurant			2025-06-30 06:39:25.84	2025-06-30 06:39:25.84				
a5ce64c4-2d11-41ef-90d4-887789323fc8	Personal			2025-06-30 06:44:10.87	2025-06-30 06:44:10.87				
ef4e5ff0-61f4-44ae-b23a-251edcb46035	Centro Hotel Al Manhal 			2025-06-30 06:59:42.258	2025-06-30 06:59:42.258		CN-2242078		
4587aacd-9c02-4aed-a82d-d97458d40a7c	Al Rawda Arjaan Hotel 			2025-06-30 07:00:34.473	2025-06-30 07:00:34.473		CN-2241148		
4d368bb3-e47c-412f-8d51-c5fe7a1b8dec	Khalidiya Palace Rayhaan			2025-06-30 07:00:55.296	2025-06-30 07:00:55.296		CN-2240612		
e95e7fc1-f565-4cae-9a0d-511a51f9e8f3	Centro Hotel Al Manhal 			2025-06-30 07:01:11.123	2025-06-30 07:01:11.123		CN-2242078		
b93a0530-99a7-4d6f-a3a1-1496c8f00bad	Blossom Hotpot Restaurant 			2025-06-30 07:09:59.11	2025-06-30 07:09:59.11		CN-4977227		
4d4e9b46-1adf-48b9-b86e-10877c3c8022	Blossom Hotpot Restaurant 			2025-06-30 07:10:39.97	2025-06-30 07:10:39.97		CN-4977227		
aef38d29-e2fe-4bbe-90cc-7995f73bf632	Spinco Cleaning Services	0559527173	carla.e@spincocleaning.com	2025-06-30 07:40:12.267	2025-06-30 07:40:12.267	Carla Mae Esperida		Sales Operation Manager	045647774 
d65af68f-e91c-4abb-942a-7deed027d333	Centro Hotel Al Manhal 			2025-06-30 07:47:51.861	2025-06-30 07:47:51.861		CN-2242078		
f7b5c6b2-3208-4033-a31e-41d291988367	Al Rawda Arjaan Hotel 			2025-06-30 07:49:01.341	2025-06-30 07:49:01.341		CN-2241148		
024c6775-7006-453d-b635-a2f1adad5cf7	Grandmas Grill and Biryani Restaurant 			2025-06-30 07:52:53.434	2025-06-30 07:52:53.434		CN-3681094		
8c0f6edf-0b50-4f85-9eca-1e985d6f4f07	Dar Karak & Muhala Restaurant 			2025-06-30 07:58:46.709	2025-06-30 07:58:46.709		CN-1048363		
4d03b881-77af-4ee1-aeed-ef04f2dc0647	Al Bait Al Soury Restaurant & Roaster	0553491461	admin@rmktheexperts.com	2025-06-30 08:10:17.454	2025-06-30 08:13:19.428	AlSadek	49278		
28534e89-f1bf-40e2-83cc-18fd1095dfb3	Al Bait Al shami Restaurant & cafeteria\t	50 785 5616/50 944 0595		2025-06-30 08:17:51.519	2025-06-30 08:17:51.519		CN-1121837		
7c4974ab-be35-45c7-a16d-19733d5b7eea	Grandmas Secret  Restaurant 			2025-06-30 08:18:21.323	2025-06-30 08:18:21.323		CN-4666434		
a1e450dc-51c5-4a90-8894-7fdcdd2543a4	Grandmas Secret  Restaurant 			2025-06-30 08:20:10.147	2025-06-30 08:20:10.147		CN-4666434		
9ae81e0c-5926-4453-b98f-75c4e81c9dd8	Al Bait Al shami Restaurant & cafeteria\t	50 785 5616/50 944 0595		2025-06-30 08:28:41.347	2025-06-30 08:28:41.347		CN-1121837		
a7a5d5ec-c70f-4620-82cc-cfd7e1c10b6b	Dar Karak & Muhala Restaurant 			2025-06-30 08:44:12.111	2025-06-30 08:44:12.111		CN-1048363		
620ebc4e-c3b7-4519-b732-fac86029eba1	Grandmas Grill and Biryani Restaurant 			2025-06-30 09:05:30.62	2025-06-30 09:05:30.62		CN-3681094		
8ceffa5f-4df9-48a0-8d22-08e5ea0fdc53	The Cousins Catering 			2025-06-30 09:13:57.521	2025-06-30 09:13:57.521				
ea9d2d21-09f6-4cef-acda-8d7c3b6070f0	The Cousins Catering 			2025-06-30 09:14:04.068	2025-06-30 09:14:04.068				
d5b778b8-a263-4790-be57-d05aa8eb584d	Al Ramla Alfadhya Restaurant\t			2025-06-30 09:52:40.013	2025-06-30 09:52:40.013		CN-2574833		
b0885885-f19f-4873-8ec2-1b0675d92ebb	Al Haj Fish Trading			2025-06-30 09:53:44.217	2025-06-30 09:53:44.217				
a06c9c85-3a6c-4e9a-ae42-71c598c5f3de	Al Haj Fish Trading			2025-06-30 09:53:49.47	2025-06-30 09:53:49.47				
f77826f6-ad8d-476c-9fea-13c26488b13e	Al Noor Modern Bakery			2025-06-30 09:54:38.397	2025-06-30 09:54:38.397				
6b229c4c-6cec-48d5-9ac6-72726808ea4a	Al Noor Modern Bakery			2025-06-30 09:54:43.22	2025-06-30 09:54:43.22				
0dc4357e-878c-4e84-a5b7-dff58f833c17	Blue Leaf Restaurant			2025-06-30 09:56:46.739	2025-06-30 09:56:46.739		CN-1699573		
1657a22b-bcf7-4562-8625-85acabab339f	Tru Boutique Café \t	563277368		2025-06-30 10:00:40.196	2025-06-30 10:00:40.196				
41aa8251-b4f6-471f-91e9-ba4b8d303125	Tru Boutique Café	0563277368		2025-06-30 10:00:58.55	2025-06-30 10:00:58.55				
984dd0d8-15cf-4d45-a1d3-62e3a87b4f90	Typing coffee shop\t	50 541 5399		2025-06-30 10:01:49.839	2025-06-30 10:01:49.839				
b7071d08-7da4-4625-a80b-9732e2b88623	Feather Cafe	50 793 0741		2025-06-30 10:02:24.531	2025-06-30 10:02:24.531				
45ffb8be-4b74-4352-ab4c-0685c159bd3f	Feather Café \t	0507930741		2025-06-30 10:02:41.318	2025-06-30 10:02:41.318				
f38de2ff-97cf-4d04-9f0a-ccc167e82ce1	Feather Café \t	0507930741		2025-06-30 10:02:56.946	2025-06-30 10:02:56.946				
5d1b976f-cb5c-49f7-8b0a-acd7b2153101	Trio Cafe	0542798894		2025-06-30 10:03:17.085	2025-06-30 10:03:17.085				
69def6ac-32e0-499a-a6ef-68f52de30b76	Trio Cafe	0542798894		2025-06-30 10:03:30.118	2025-06-30 10:03:30.118				
30eb3b71-8c1e-4c92-89bc-0a714a512a5e	Piece of Café\t	0569238807		2025-06-30 10:03:49.293	2025-06-30 10:03:49.293				
6e867719-c139-42ee-aa51-6b3458489fb3	Piece of Café\t	0569238807		2025-06-30 10:04:02.398	2025-06-30 10:04:02.398				
bf0cd229-109c-4524-a6b4-1f7ca6b48cae	Harees  Al Majlis Traditional Food	0506383660		2025-06-30 10:04:33.9	2025-06-30 10:04:33.9				
9c34e918-d28e-465c-8fcf-79ab1502b85b	Harees  Al Majlis Traditional Food	0506383660		2025-06-30 10:04:56.58	2025-06-30 10:04:56.58				
6e446aef-27b7-4780-a038-aea46058d0a3	Harees  Al Majlis Traditional Food	0506383660		2025-06-30 10:05:14.135	2025-06-30 10:05:14.135				
203e37b8-ca6a-47a3-b66f-3642f5c0499e	Harees  Al Majlis Traditional Food	0506383660		2025-06-30 10:05:30.908	2025-06-30 10:05:30.908				
6ff3b805-c458-4876-af4f-575791934899	Harees  Al Majlis Traditional Food	0506383660		2025-06-30 10:06:14.884	2025-06-30 10:06:14.884				
46dccab8-2a15-4644-bb27-1934573621ea	Harees  Al Majlis Traditional Food	0506383660		2025-06-30 10:06:19.169	2025-06-30 10:06:19.169				
0b49bc6a-b181-4fb4-81c7-2baf046e008a	Typing coffee shop\t	50 541 5399		2025-06-30 10:06:23.667	2025-06-30 10:06:23.667				
2fb95c02-dd01-4aaa-8417-19e22b0000fb	Tru Boutique Café	0563277368		2025-06-30 10:06:27.262	2025-06-30 10:06:27.262				
3c7c2444-ed0c-483f-8ea4-3ec80de01da6	Tru Boutique Café \t	563277368		2025-06-30 10:06:30.751	2025-06-30 10:06:30.751				
7c1d804a-71c7-46b8-b2b7-ef793725f6be	Ayla Hotels & Resort			2025-06-30 10:14:12.218	2025-06-30 10:14:12.218				
7c39ac88-9eed-4961-bb3f-db85702da6dc	Ayla Hotels & Resort			2025-06-30 10:14:41.64	2025-06-30 10:14:41.64				
58f6270f-0164-4ae4-b2c0-d2648c9c995d	On the Block Cafe	50 743 2157		2025-06-30 10:16:54.023	2025-06-30 10:16:54.023				
5d4e709d-2b4b-4bdc-84b1-e205474cfe97	Grandmas Grill and Biryani Restaurant 			2025-06-30 11:05:14.042	2025-06-30 11:05:14.042		CN-3681094		
cb0329b2-ab12-4893-ae02-37e5f8b1161f	Baqala	50 141 0097		2025-06-30 12:38:08.269	2025-06-30 12:38:08.269				
c3760cdd-861b-4e72-9c69-c0de061eca07	Twister One Grocery	50 141 0097		2025-06-30 12:44:39.5	2025-06-30 12:44:39.5				
d01e5c24-9ea4-42f4-a5d0-fdd9e8cf6d07	Al Rahi Baqala 			2025-06-30 13:00:25.07	2025-06-30 13:00:25.07				
00c07b73-a30e-47c4-9386-8b23280e56a4	Al Rahi Baqala 			2025-06-30 13:00:34.172	2025-06-30 13:00:34.172				
ac5f5644-76b6-431e-bf2d-f9dd55446870	Air Fresh  Baqala 			2025-06-30 13:02:55.536	2025-06-30 13:02:55.536				
c7b5ae38-321d-4884-aedb-3d0f47bd2f76	Twister One Grocery	50 141 0097		2025-06-30 13:29:17.618	2025-06-30 13:29:17.618		CN-4485594		
3ec6f696-ad7e-4d0c-98c2-f64839d855ba	Al Ramla Alfadhya Restaurant\t			2025-06-30 13:29:44.313	2025-06-30 13:29:44.313		CN-2574833		
8e1edab3-6e50-4878-a39c-c9c9884f80f2	Just Silver Cafeteria	56 956 4786		2025-06-30 13:30:34.298	2025-06-30 13:30:34.298		CN-1125519		
aa9ca807-95d9-4324-a8e8-6a4f397f6854	Al Haj Fish Trading			2025-06-30 13:31:27.488	2025-06-30 13:31:27.488		CN-1134865		
264f3f3b-cce7-4f1f-97dd-d7380c618efb	Top Choice Baqala \t	566592424		2025-06-30 14:31:07.147	2025-06-30 14:31:07.147		CN-3837255		
bf77112a-0531-42b0-b4df-8444371714ac	Dream Life General Trading\t	504729622		2025-06-30 14:31:35.184	2025-06-30 14:31:35.184		CN-5488117		
82020e69-ef0d-4cc1-ba3b-67a738fdfc9a	Special Touch Meat and Fish Trading\t	568477499		2025-06-30 14:32:05.802	2025-06-30 14:32:05.802		CN-5605760		
c10bf43c-ee21-46b4-981e-cff14f2346e5	Ishq Grocery	55 972 0275		2025-06-30 14:32:46.54	2025-06-30 14:32:46.54		CN-3686414		
dede27ef-a7a7-482b-9611-b59c5e980f2f	World Gate Baqala	582248919		2025-06-30 14:33:15.061	2025-06-30 14:33:15.061		CN-5201370		
0a7cb3d2-949d-408c-87fb-629b190536ad	Zahrathul Murijib grocery \t	504142227		2025-06-30 14:33:40.688	2025-06-30 14:33:40.688		CN-4366902		
cf23fd2f-924c-40f9-9f0e-ce3de4107ba6	Twister One Grocery	50 141 0097		2025-06-30 14:34:14.093	2025-06-30 14:34:14.093		CN-4485594		
0be7f023-2dca-4711-bda4-4a5015818567	Al Mallah Restaurant & Grills\t	557135252		2025-06-30 14:34:31.563	2025-06-30 14:34:31.563		CN-1113909		
d466e0f2-fa2d-4d29-970b-ced1003142e8	Wahat Algaia Restaurant 	502004572		2025-06-30 14:34:56.727	2025-06-30 14:34:56.727		CN-4253239		
4e68c942-cbf3-433e-8a57-62916a2337f5	Al Ramla Alfadhya Restaurant\t			2025-06-30 14:35:21.589	2025-06-30 14:35:21.589		CN-2574833		
9cd597de-32f3-4e16-8a80-e2faead4e48c	Zad Al Khair Catering \t			2025-06-30 14:35:36.423	2025-06-30 14:35:36.423		CN-2837838		
8a014f71-276b-41ad-bdbc-7c792e548169	Zad Al Khair Catering \t			2025-06-30 14:35:59.854	2025-06-30 14:35:59.854		CN-2837838		
8fb2cafa-9469-4ae4-8f3b-daefb0a94845	Al Raya Restaurant	91 96054 57494/971562757052		2025-06-30 14:36:29.888	2025-06-30 14:36:29.888		CN-1113179		
27970293-867d-4523-b31e-4d5af5c2d0a7	Al Raya Restaurant	91 96054 57494/971562757052		2025-06-30 14:36:38.058	2025-06-30 14:36:38.058		CN-1113179		
dbfc90b1-c4a3-477b-9cc4-3183e89c77b5	Al Haj Fish Trading			2025-06-30 14:37:13.605	2025-06-30 14:37:13.605		CN-1134865		
c0d70436-de79-45b3-9d7c-975bd4fd21f3	Blue Leaf Restaurant			2025-06-30 14:37:36.66	2025-06-30 14:37:36.66		CN-1699573		
710c8ef8-9923-4e92-aaf8-6f3650fde7ed	Dream Life General Trading\t	504729622		2025-07-01 04:30:16.061	2025-07-01 04:30:16.061		CN-5488117		
35d7d1b5-75ab-40d4-a074-14194833323f	Twister One Grocery	50 141 0097		2025-07-01 04:34:24.645	2025-07-01 04:34:24.645		CN-4485594		
a00c832c-b954-4447-8664-bbe1f0e06985	The Prince   Cafe 			2025-07-01 04:38:42.466	2025-07-01 04:38:42.466		CN-1024717		
43cc469d-72fc-4c8f-b35e-f56fbd154816	Special Touch Meat and Fish Trading\t	568477499		2025-07-01 04:40:43.324	2025-07-01 04:40:43.324		CN-5605760		
6b84d488-bf5d-42b3-82bf-5368adb6e885	Special Touch Meat and Fish Trading\t	568477499		2025-07-01 04:41:31.49	2025-07-01 04:41:31.49		CN-5605760		
af010fce-9d69-4d5c-a0fd-56f20dbdd928	World Gate Baqala	582248919		2025-07-01 04:44:13.052	2025-07-01 04:44:13.052		CN-5201370		
23a7dd2d-6aa6-444f-ba15-1a8f8a7509bb	Caboodle Pamper and Play			2025-07-01 04:44:27.153	2025-07-01 04:44:27.153		000000157		
1481cbe2-91cb-4760-86e8-daabd0c2b99c	Just Silver Cafeteria	56 956 4786		2025-07-01 04:51:13.944	2025-07-01 04:51:13.944		CN-1125519		
608429cc-49dd-41d8-ae76-d290cba49e1a	Abu saood Trading Establishment			2025-07-01 04:51:25.258	2025-07-01 04:51:25.258		CN-1036625		
e6db72ec-0792-4be8-a083-5e4e4b4c6512	Abu saood Trading Establishment			2025-07-01 04:52:32.702	2025-07-01 04:52:32.702		CN-1036625		
20ab3e98-8a27-4f13-98e4-a528c9230e51	Abu saood Trading Establishment			2025-07-01 04:53:27.55	2025-07-01 04:53:27.55		CN-1036625		
d40180da-cf40-4cf9-9ac8-934e75173b64	Abu saood Trading Establishment			2025-07-01 04:54:22.739	2025-07-01 04:54:22.739		CN-1036625		
0cd65ff6-7d90-495b-b32a-adb3fabfa41d	Al Rahi Baqala 			2025-07-01 04:56:12.971	2025-07-01 04:56:12.971		CN-1016734		
1b2ef989-f99c-4cee-a1e5-c3abdd8f13c9	Blue Leaf Restaurant			2025-07-01 04:57:17.474	2025-07-01 04:57:17.474		CN-1699573		
133644d3-7789-4a43-869a-dcf83fab1604	Al Rahi Baqala 			2025-07-01 04:57:53.209	2025-07-01 04:57:53.209		CN-1016734		
bee5f148-d509-4e0d-89b3-a7a0bc55b20e	Pinoy Grocery 			2025-07-01 04:58:56.295	2025-07-01 04:58:56.295		CN-1026891		
2ee49c70-056b-4a54-a156-d4f04c66a735	Zad Al Khair Catering \t			2025-07-01 05:00:16.044	2025-07-01 05:00:16.044		CN-2837838		
e7a28084-aa60-4db1-92a1-95d84fd9ac21	Caboodle Pamper and Play			2025-07-01 05:00:43.599	2025-07-01 05:00:43.599		000000157		
cf09a47b-745d-4a45-956f-164ec38a0a22	Zad Al Khair Catering \t			2025-07-01 05:01:01.531	2025-07-01 05:01:01.531		CN-2574833		
944e3df2-6318-4fc7-8f61-4dccec8cb44c	Kumbakom Cafe 			2025-07-01 05:03:39.268	2025-07-01 05:03:39.268		CN-5655223		
9cc4c211-d099-4873-a20c-9730ce4da50e	Zad Al Khair Catering \t			2025-07-01 05:05:33.699	2025-07-01 05:05:33.699		CN-2837838		
0d9de9c0-fd54-4ce9-80ae-abdcbe4b97f1	Zahrathul Murijib grocery \t	504142227		2025-07-01 05:09:16.419	2025-07-01 05:09:16.419		CN-4366902		
900d4483-7e3a-4c98-b4b2-a4b3e8e2c745	Al Raya Restaurant	91 96054 57494/971562757052		2025-07-01 05:27:18.355	2025-07-01 05:27:18.355		CN-1113179		
6fa20174-5e17-4a3a-9801-41eaa57a7cda	Shawarma Street  Br.2			2025-07-01 05:27:48.84	2025-07-01 05:27:48.84		CN-1771707-2		
a7f3869e-361a-4197-ba4e-8458c85c8b03	Let's Talk Riz Corner Café 			2025-07-01 05:30:48.802	2025-07-01 05:30:48.802		CN-2585722		
94c3f3fc-786a-4eca-98ed-04fe6e22ad3b	Al Haj Fish Trading			2025-07-01 05:30:52.702	2025-07-01 05:30:52.702		CN-1134865		
d3c2920d-3444-40f1-8edf-97a02f0b8eea	Let's Talk Riz Corner Café 			2025-07-01 05:32:42.93	2025-07-01 05:32:42.93		CN-2585722		
ae555430-6dff-4c68-841c-17161c44093d	Wahat Algaia Restaurant 	502004572		2025-07-01 05:32:59.766	2025-07-01 05:32:59.766		CN-4253239		
29324bd9-5837-458c-a2ab-50cbf2bda098	Al Noor Modern Bakery			2025-07-01 05:13:32.657	2025-07-01 05:13:32.657		CN-1115138-2		
321ef2ff-0961-4a6f-961d-4f1309daa414	Top Choice Baqala \t	566592424		2025-07-01 05:18:12.541	2025-07-01 05:18:12.541		CN-3837255		
989514ae-a772-41f9-807b-7ab6a9d9ebe7	Baqala Attraction 			2025-07-01 05:19:48.745	2025-07-01 05:19:48.745		CN-1021408		
14be4179-7234-4cfc-bca2-6aba74bc9181	Baqala Attraction 			2025-07-01 05:19:58.179	2025-07-01 05:19:58.179		CN-1021408		
05744924-5242-4b0b-83f8-163094b5ff87	Al Mallah Restaurant & Grills\t	557135252		2025-07-01 05:22:12.118	2025-07-01 05:22:12.118		CN-1113909		
ee67085b-9e95-4878-adb8-ad832a72e5c4	Baqala Attraction 			2025-07-01 05:22:25.33	2025-07-01 05:22:25.33				
01c9e661-29f2-4bf9-ba95-bc564b3de45c	Baqala Ismail Lari			2025-07-01 05:24:10.924	2025-07-01 05:24:10.924		CN-1016277		
058e83e7-870d-440f-a67f-0f77afbd5ee3	Air Fresh  Baqala 			2025-07-01 05:34:04.938	2025-07-01 05:34:04.938		CN-2715104		
68d791a3-dafd-4b0c-90a0-3c5b44c9af93	Air Fresh  Baqala 			2025-07-01 05:36:28.594	2025-07-01 05:36:28.594				
f738c5c4-c785-4a46-ac9f-6e346e7c4c7d	Shawarma Street  Br.2			2025-07-01 05:38:14.547	2025-07-01 05:38:14.547		CN-1771707-2		
643df1e6-4cc0-4fa8-be68-389b3dea8604	Shawarma Street  Br.2			2025-07-01 05:38:30.724	2025-07-01 05:38:30.724		CN-1771707-2		
4d80daf1-5bf2-4a8e-bf8f-87ca9ec6fcec	Blossom Hotpot Restaurant 			2025-07-01 05:46:38.906	2025-07-01 05:46:38.906		CN-4977227		
6426cc60-3e6d-41bf-8929-1a7325015148	Ishq Grocery	55 972 0275		2025-07-01 05:58:54.369	2025-07-01 05:58:54.369		CN-3686414		
d15e37b7-4f16-4441-ac0c-bac932e03479	Special Touch Meat and Fish Trading\t	568477499		2025-07-01 06:08:15.735	2025-07-01 06:08:15.735		CN-5605760		
4ff57224-1b8d-42cc-ad51-987d550f92dd	Shawarma Street  Br.3			2025-07-01 06:09:24.769	2025-07-01 06:09:24.769		CN-177170-3		
83532c72-6dd6-46d2-a249-51ccefd61f08	Wahat Algaia Restaurant 	502004572		2025-07-01 06:12:26.956	2025-07-01 06:12:26.956		CN-4253239		
f1a8f379-ae4b-49ce-80b9-a863288878dc	Wahat Algaia Restaurant 	502004572		2025-07-01 06:13:37.195	2025-07-01 06:13:37.195		CN-4253239		
f9880784-cde2-47fc-ac98-b1404fbc9351	Al Haj Fish Trading			2025-07-01 06:20:17.74	2025-07-01 06:20:17.74		CN-1134865		
75029cf2-465f-44be-9e87-7100e93a199b	Abm Baqala 			2025-07-01 06:26:45.752	2025-07-01 06:26:45.752				
c0c1eaa0-0994-48f6-bbda-56cfead3cacc	Ishq Grocery	55 972 0275		2025-07-01 06:47:04.012	2025-07-01 06:47:04.012		CN-3686414		
6df79867-835b-49cd-a691-c86188504e2d	Air Fresh  Baqala 			2025-07-01 06:53:19.28	2025-07-01 06:53:19.28		CN-2715104		
2bfed670-750a-48df-8c71-7264cdb0e2ef	Air Fresh  Baqala 			2025-07-01 06:58:18.348	2025-07-01 06:58:18.348		CN-2715104		
e8e51c2f-4e4c-4476-ade2-faf5d0eaa8a2	Al Khayyat Investment (AKI)	0564149719		2025-07-01 07:25:14.093	2025-07-01 07:25:14.093				
427247a8-1877-49d1-bb69-6b94b5c9f3ad	Just Break Cafeteria\t	50 219 3600		2025-07-01 07:26:03.765	2025-07-01 07:26:03.765		CN-5675932		
5e9464b2-c41c-4f3e-8120-6c6713bb84f9	Blue Leaf Restaurant			2025-07-01 07:26:39.21	2025-07-01 07:26:39.21		CN-1699573		
ca3675b1-cecb-4760-b12f-eb2c307d28a6	Wahat Algaia Restaurant 	502004572		2025-07-01 07:29:07.837	2025-07-01 07:29:07.837		CN-4253239		
d490ec70-4c76-4047-bfda-40bdab121e4c	Just Break Cafeteria\t	50 219 3600		2025-07-01 07:31:39.823	2025-07-01 07:31:39.823		CN-5675932		
dee79972-5ea6-4b6a-9943-6568858e1786	Just Break Cafeteria\t	50 219 3600		2025-07-01 07:32:34.665	2025-07-01 07:32:34.665		CN-5675932		
2f28157b-095d-4319-9ea7-d87a27553689	Zad Al Khair Catering \t			2025-07-01 07:48:13.774	2025-07-01 07:48:13.774		CN-2837838		
dd17097c-8c70-4d3b-922c-c4f1ebba3d5c	Al Ramla Alfadhya Restaurant\t			2025-07-01 07:50:33.032	2025-07-01 07:50:33.032		CN-2574833		
f9934966-8ed0-4d6d-a757-2399bd0b973e	Zad Al Khair Catering \t			2025-07-01 07:50:58.734	2025-07-01 07:50:58.734		CN-2837838		
2a9e0494-4b88-451c-ba43-02a865964ec1	Al Ramla Alfadhya Restaurant\t			2025-07-01 07:52:21.234	2025-07-01 07:52:21.234		CN-2574833		
c5da0384-c10c-449f-a344-35ccd73ea72b	Al Raya Restaurant	91 96054 57494/971562757052		2025-07-01 07:55:48.492	2025-07-01 07:55:48.492		CN-1113179		
73cb85dc-095a-4a32-8124-0114cda764ff	Al Haj Fish Trading			2025-07-01 08:16:22.002	2025-07-01 08:16:22.002		CN-1134865		
7066b770-f768-4777-bdf7-b8bebb598acc	Eagle Environmental Services & Pest Control	0564149719		2025-07-01 09:10:34.996	2025-07-01 09:10:34.996	Eng Ibrahim			
8724ac68-3290-4c25-8278-b0363f511f3d	Al Khayyat Investment (AKI)	0564149719		2025-07-01 09:33:38.951	2025-07-01 09:33:38.951				
8037b4e1-2f52-4140-8ec2-5be3641d2470	Al Khayyat Investment (AKI) Al Ain	0507657673	ahmed.elt@akigroup.com	2025-07-01 09:51:23.73	2025-07-01 09:51:23.73	Ahmed Mohamed Rabie Eltamady		Supervisor - Environmental Services	048105555
74067380-4cef-4f75-ad5e-66fe3fe1cb79	Al Khayyat Investments  (AKI) AUH	0503899758	alzhraa.z@akigroup.com	2025-06-28 06:34:05.134	2025-07-01 09:53:36.835	Alzhraa Yaser Zoghbi		Coordinator - SEHA Project AUH – Lot 4	048105555
ec53b5c8-1a61-4eaf-b91a-ed34ec7bc85f	Tierra Café \t	52 763 2334-farsana		2025-07-01 10:16:30.69	2025-07-01 10:16:30.69				
52f9e915-e4cf-4106-8f65-3a1661237867	Tierra Café \t	52 763 2334-farsana		2025-07-01 10:16:35.129	2025-07-01 10:16:35.129				
b9f486e6-6b1b-4e84-aaf4-a30e4734ecf1	Lamars rest and café	971 56 229 2557-farsana		2025-07-01 10:16:40.341	2025-07-01 10:16:40.341				
ecd9b204-23a4-4507-a376-01a9f3e6aa82	Lamars rest and café	971 56 229 2557-farsana		2025-07-01 10:16:44.997	2025-07-01 10:16:44.997				
af5771de-e377-436c-9dfd-4b45c780cf9f	Lamars rest and café	971 56 229 2557-farsana		2025-07-01 10:16:49.091	2025-07-01 10:16:49.091				
98b77405-35dd-4eca-bcb3-34f58b5af04f	Lamars rest and café			2025-07-01 10:16:53.118	2025-07-01 10:16:53.118				
1b9685c1-cd6c-4558-953a-546d32956820	Lamars rest and café			2025-07-01 10:16:57.29	2025-07-01 10:16:57.29				
dc5e39cb-9e84-41e9-8545-65249c1f8766	Al Remal Thahabeya Restaurant\t	50 731 3327		2025-07-01 10:17:35.919	2025-07-01 10:17:35.919		CN-1105289		
88d1f4d1-e5ff-4798-a32f-084c82910d14	Restaurant	50 909 3676		2025-07-01 10:18:08.226	2025-07-01 10:18:08.226				
67892695-6287-4f8c-bbda-cdc28418edba	50 909 3676			2025-07-01 10:18:19.498	2025-07-01 10:18:19.498				
71bc0f35-e6c2-4f31-af87-195be5aa8db5	Restaurant	50 909 3676		2025-07-01 10:18:38.801	2025-07-01 10:18:38.801				
c84fc8cc-221b-415a-a6de-ee37ae930f30	Al Mallah Restaurant & Grills	562734798    		2025-07-01 10:19:03.224	2025-07-01 10:19:03.224				
3cce8065-dd7b-4bb5-a74f-93c2cfdcaa87	Al Anqaa Grocery Shop \t	50 569 2486		2025-07-01 10:19:43.835	2025-07-01 10:19:43.835				
51641595-5cf9-4432-a875-aabf9e833aa8	AL noorain vef and fruits\t	504148690		2025-07-01 10:20:06.183	2025-07-01 10:20:06.183				
859a28e3-b807-4c02-8b0a-4f51162ee448	Lulu Al Sahra Food Stuff Stores L.L.C\t	56 964 2465		2025-07-01 10:21:23.823	2025-07-01 10:21:23.823				
8213fbd6-b160-4631-a089-5cf4628dbcd3	Internatonal Grandmart Supermarket	0558589241	hr@grandmart.ae	2025-07-01 10:21:39.504	2025-07-01 10:21:39.504	Raquel dela Cruz	CN-1373440-2	HR Coordinator	037633001
01d5197a-9663-4f63-ba8d-de980dbe004f	Baqala	55 137 5732		2025-07-01 10:22:04.42	2025-07-01 10:22:04.42				
988ae71c-5ebf-4535-9fdf-bc7d1b86a51f	Baqala	0551375732		2025-07-01 10:22:19.721	2025-07-01 10:22:19.721				
e9bc293d-a63c-40f2-971a-259680d554b3	Grocery	55 742 3413		2025-07-01 10:22:44.125	2025-07-01 10:22:44.125				
8663dc51-7b15-473f-a39a-8d8e0e2f70a9	Feather Cafe	54 776 9038		2025-07-01 10:28:18.028	2025-07-01 10:28:18.028				
7290a524-2d05-484f-941e-1e5c0d05c294	Feather Cafe	0547769038		2025-07-01 10:28:36.998	2025-07-01 10:28:36.998				
1e7f91a5-eb06-49ea-a2ae-5be2116ee9a8	Flamingo Events	56 521 2249		2025-07-01 10:29:19.001	2025-07-01 10:29:19.001				
bd1d042b-c81d-4b48-b70a-839ecf3bfc6f	Flamingo Events	0565212249		2025-07-01 10:31:03.681	2025-07-01 10:31:03.681				
0fd34dfa-b206-411c-b18f-55d760883286	Margin Café\t	50 690 5404		2025-07-01 10:31:25.336	2025-07-01 10:31:25.336				
b6af8f5e-6026-4ddf-9801-5cee82e5fc44	Margin Café	0506905404		2025-07-01 10:31:41.929	2025-07-01 10:31:41.929				
b07652af-fbff-4a9e-9b10-46bb111ae6bf	Margin Café	0506905404		2025-07-01 10:32:48.817	2025-07-01 10:32:48.817				
0f69334d-7b9f-4c91-a7d6-36d322afe360	Grand mart			2025-07-01 10:37:18.817	2025-07-01 10:37:18.817				
effb4dd6-3b9e-467b-bebe-8c9f64acbe4a	Grand mart			2025-07-01 10:37:30.543	2025-07-01 10:37:30.543				
94ceab2a-5ad8-4f9b-bb66-396c83989458	Grand mart			2025-07-01 10:37:50.226	2025-07-01 10:37:50.226				
2a20e14f-9b1c-46a5-8732-585562e37f2f	Grand mart			2025-07-01 10:38:06.535	2025-07-01 10:38:06.535				
d771a4e6-ac27-48ad-ab8c-9dc3e79a35d0	Cro Bakery and Cafe			2025-07-01 10:39:21.254	2025-07-01 10:39:21.254				
f221ac27-6e72-4fe1-9774-57b2b075d127	Cro Bakery and Cafe			2025-07-01 10:39:38	2025-07-01 10:39:38				
f56d0ebc-4b95-4340-8fe2-18be93e9de68	Cro Bakery and Cafe			2025-07-01 10:39:56.853	2025-07-01 10:39:56.853				
2f57b090-f51b-4da2-9547-f74b6a8c8b45	Cro Bakery and Cafe			2025-07-01 10:40:32.195	2025-07-01 10:40:32.195				
2e8fe110-b047-4878-9db2-0b8793de8c91	Cro Bakery and Cafe			2025-07-01 10:40:53.539	2025-07-01 10:40:53.539				
5798e395-88a6-4e9b-b8a2-f2cb1e3e9a43	Cro Bakery and Cafe			2025-07-01 10:40:58.178	2025-07-01 10:40:58.178				
c959373f-cc47-4ad7-97fd-142a66a7162d	Cro Bakery and Cafe			2025-07-01 10:41:09.429	2025-07-01 10:41:09.429				
69d95ac7-e4e1-455d-aa8f-c544a8140eea	Cro Bakery and Cafe			2025-07-01 10:41:17.94	2025-07-01 10:41:17.94				
3416ccee-a6ae-48e6-b81d-562c98859ef7	Cro Bakery and Cafe			2025-07-01 10:41:27.785	2025-07-01 10:41:27.785				
707998e9-3cc0-47ca-ae6a-7254e79c2157	Cro Bakery and Cafe			2025-07-01 10:41:39.714	2025-07-01 10:41:39.714				
fd736fee-e6be-4f71-bfcc-55004102d7b1	Coriander Restaurant \t			2025-07-01 10:41:53.529	2025-07-01 10:41:53.529				
ea71509f-cd3d-4cb7-bb36-dc3f86a72a22	Coriander Restaurant \t			2025-07-01 10:42:13.918	2025-07-01 10:42:13.918				
83d52a13-a52f-4208-9b59-fd7a39ab44ba	Tierra Cafe			2025-07-01 10:43:01.669	2025-07-01 10:43:01.669				
f57be3b9-7c3d-4316-b1f8-2455a4dbeee0	Tierra Cafe			2025-07-01 10:43:05.23	2025-07-01 10:43:05.23				
9cf1b65d-5941-4e0f-9f63-22701a9c07ba	Tierra Cafe			2025-07-01 10:43:10.524	2025-07-01 10:43:10.524				
cded10e7-07d9-481f-b785-1ab5fa9b8df7	Tierra Cafe 			2025-07-01 10:43:15.054	2025-07-01 10:43:15.054				
448a3569-0457-4c22-a157-49805c9fde4f	Tierra Cafe			2025-07-01 10:43:19.487	2025-07-01 10:43:19.487				
ffe0bdb1-dfa6-4d5e-845b-d4a3faf3248c	Tierra Cafe			2025-07-01 10:43:23.195	2025-07-01 10:43:23.195				
5812ea52-cd56-493a-9891-01e4a5ca4725	Tierra Cafe			2025-07-01 10:43:26.648	2025-07-01 10:43:26.648				
c2e09ee4-1ef9-49c5-95e5-6bc7b795c6c9	Tierra Cafe			2025-07-01 10:43:30.453	2025-07-01 10:43:30.453				
51083fe4-ada8-4675-acfd-ce4c22f419e4	\tBurger Stop Cafeteria\t	50 233 3157		2025-07-01 10:44:43.035	2025-07-01 10:44:43.035		\tCN-2174527		
6eb88f75-61cb-4324-b127-6ac619450603	Burger Stop Cafeteria	0502333157		2025-07-01 10:44:59.346	2025-07-01 10:44:59.346				
2d3aa439-9ef2-48c3-9b9c-9af3e34f60c4	Zad Al Khair Catering \t			2025-07-01 10:48:32.633	2025-07-01 10:48:32.633		CN-2837838		
c3caebf1-57a8-416f-9b99-168dd82d6843	Delicacy Vita Flowers and Sweets\t			2025-07-01 10:48:39.775	2025-07-01 10:48:39.775		CN-5611228		
c2f4a820-9999-4fce-b19e-7c6682adf04a	Lamars rest and café	971 56 229 2557-farsana		2025-07-01 10:48:46.841	2025-07-01 10:48:46.841				
f5884e30-e4ce-491a-b0b7-a19928cf4fdc	Lamars rest and café	971 56 229 2557-farsana		2025-07-01 10:48:54.58	2025-07-01 10:48:54.58				
acb41c75-2a87-40a6-b8fa-20306d224edf	Lamars rest and café			2025-07-01 10:49:38.548	2025-07-01 10:49:38.548				
d9d625df-e611-4201-8607-361d6f5632d5	Lamars rest and café			2025-07-01 10:49:51.4	2025-07-01 10:49:51.4				
b263a355-5ba9-4269-b257-b888eb9e8719	Al Noor Modern Bakery	55 863 7577		2025-07-01 10:50:43.245	2025-07-01 10:50:43.245				
0f605fd0-c2c3-43fd-9135-ba7144722905	Al Noor Modern Bakery	0558637577		2025-07-01 10:51:00.141	2025-07-01 10:51:00.141				
edbb90be-6400-4177-a402-3e1eeac9c43f	Al Noor Modern Bakery			2025-07-01 10:51:34.053	2025-07-01 10:51:34.053				
7ce33dd7-06eb-4518-9a72-f95c59d4996c	Brwon chocolates	 50 566 9136		2025-07-01 10:52:19.518	2025-07-01 10:52:19.518				
9909caeb-3642-42ce-801b-6c0e6c950125	Guld and safa diaries	 55 100 7105		2025-07-01 10:53:11.214	2025-07-01 10:53:11.214				
5bb2edb9-204b-4d63-8637-2c4db6c38a0b	Guld and safa diaries			2025-07-01 10:53:33.583	2025-07-01 10:53:33.583				
31382e31-518b-4cf8-82ed-f93cdb4a5773	Guld and safa diaries			2025-07-01 10:53:38.106	2025-07-01 10:53:38.106				
17b8d5ce-ea34-4dd0-8ad0-92de5ea0fa91	Flowers			2025-07-01 10:54:17.7	2025-07-01 10:54:17.7				
36d72866-b06a-44b9-9a45-919405d13257	Grand mart			2025-07-01 10:54:54.882	2025-07-01 10:54:54.882				
0ca311a1-61ba-4465-b651-3b0740616df7	Grand mart			2025-07-01 10:55:10.648	2025-07-01 10:55:10.648				
0fc1b73a-58b3-4a76-ab2a-540a43fdfd44	Grand mart			2025-07-01 10:58:19.196	2025-07-01 10:58:19.196				
f977eec9-8a04-42c5-9d0c-c81fd19babfd	Grand mart			2025-07-01 10:58:23.906	2025-07-01 10:58:23.906				
32f456df-aa05-4b82-916c-b2dcb3ccafae	Grand mart			2025-07-01 10:58:27.414	2025-07-01 10:58:27.414				
695382fd-2793-4557-a0bf-16034934e9fa	Grand mart			2025-07-01 10:58:32.507	2025-07-01 10:58:32.507				
33581069-b3ab-4fff-9605-007292a0e95e	Cro Bakery and Cafe			2025-07-01 10:58:37.07	2025-07-01 10:58:37.07				
37fecb28-faea-449f-916f-f2eba5b3aa8d	Cro Bakery and Cafe			2025-07-01 10:58:40.949	2025-07-01 10:58:40.949				
73e76091-354a-475f-a154-e27da6efce5f	Cro Bakery and Cafe			2025-07-01 10:58:44.473	2025-07-01 10:58:44.473				
5e69e1ef-b83d-4709-8c14-20ac942f8438	Cro Bakery and Cafe			2025-07-01 10:58:47.843	2025-07-01 10:58:47.843				
50eede9c-ac48-4c76-91bd-479fe948e0c6	Cro Bakery and Cafe			2025-07-01 10:58:51.207	2025-07-01 10:58:51.207				
2c9e4e69-4c4d-40fd-b573-d3350961941a	Cro Bakery and Cafe			2025-07-01 10:58:56.238	2025-07-01 10:58:56.238				
e181b181-38ee-4b36-8f7e-7312d19d9b95	Cro Bakery and Cafe			2025-07-01 10:58:59.555	2025-07-01 10:58:59.555				
5db504ae-199a-4240-9e14-4115e822be44	Cro Bakery and Cafe			2025-07-01 10:59:03.036	2025-07-01 10:59:03.036				
ced44939-c31a-4f37-a74b-ece8650004d3	Cro Bakery and Cafe			2025-07-01 10:59:07.839	2025-07-01 10:59:07.839				
50c2e7cf-ebaf-46a8-909d-1021d21ba1c7	Cro Bakery and Cafe			2025-07-01 10:59:11.424	2025-07-01 10:59:11.424				
5adad621-9738-437d-a4f5-46a1e18b8eb5	Cro Bakery and Cafe			2025-07-01 10:59:15.047	2025-07-01 10:59:15.047				
744ba7cc-d7f1-480c-9982-715e4b8d3755	Delicace Boutique	56 331 1242		2025-07-01 11:32:49.728	2025-07-01 11:32:49.728				
3fc49385-8158-4644-9d40-f1f84342f4ee	Al Kulaifi Refreshments 			2025-07-01 11:33:07.341	2025-07-01 11:33:07.341		CN-1037376		
22c90fa0-39f2-4e67-9685-38c9fb1f8b65	Family Refreshments			2025-07-01 11:34:24.254	2025-07-01 11:34:24.254				
3eabf73e-c6ab-4e63-ae5d-cba8d6f8c93a	Delicace Boutique	56 331 1242		2025-07-01 12:52:44.329	2025-07-01 12:52:44.329				
6328132f-5798-4423-b9fe-6f437e2cb327	harees	56 617 8772		2025-07-02 04:46:42.413	2025-07-02 04:46:42.413				
7c5f311f-ecad-46b4-a879-7c7e6327bc41	harees	0566178772		2025-07-02 04:47:11.547	2025-07-02 04:47:11.547				
9fafe795-5822-413e-8c17-d235c43736c3	AL noorain vef and fruits	0504148690		2025-07-02 04:48:05.478	2025-07-02 04:48:05.478				
c6dace27-b9ab-4dc1-84f9-09e440734f04	McDonald's			2025-07-02 04:48:10.529	2025-07-02 04:48:10.529				
9270cb06-13e6-449a-8c3a-7ce10206aecf	McDonald's			2025-07-02 04:48:51.53	2025-07-02 04:48:51.53				
4b91e201-6351-46fc-a028-6eeb5666ae1d	McDonald's			2025-07-02 04:48:58.269	2025-07-02 04:48:58.269				
118e604b-0280-496a-8bae-21f021dd99fc	McDonald's			2025-07-02 04:49:07.136	2025-07-02 04:49:07.136				
35da70a8-8d82-4fa0-90e0-4c96ed10e2d2	Harees restaurant	0566178772		2025-07-02 04:49:13.865	2025-07-02 04:49:13.865				
d213ba81-c530-4f0b-9a6b-0f4b059d922b	McDonald's			2025-07-02 04:49:19.618	2025-07-02 04:49:19.618				
5793b32e-b0e1-4550-8427-f0f43e8bc7f7	McDonald's			2025-07-02 04:49:32.052	2025-07-02 04:49:32.052				
39f9cb10-b130-42f3-8cd2-53256a2e24f1	Harees restaurant	0566178772		2025-07-02 04:49:33.526	2025-07-02 04:49:33.526				
66b527fd-ef09-444a-b976-569fdb8e12a5	McDonald's			2025-07-02 04:49:41.594	2025-07-02 04:49:41.594				
ff93a4a1-4946-4e25-8682-38de6ab22b97	Mohammed Bin Khaled Al Nahyan Generational School	54 271 7335		2025-07-02 06:14:13.341	2025-07-02 06:14:13.341		CN-1005363		
096624e5-b50e-4900-ae06-baeca9847f91	Mohammed Bin Khaled Al Nahyan Generational School	54 271 7335		2025-07-02 06:14:17.173	2025-07-02 06:14:17.173		CN-1005363		
19d4b87c-33a8-415a-8992-32a4db88b3cd	Mohammed Bin Khaled Al Nahyan Generational School	54 271 7335		2025-07-02 06:22:50.81	2025-07-02 06:22:50.81		CN-1005363		
f58f377c-fef7-4122-ad2a-79bd15dd059a	Al Rowdha Restaurant	52 849 3811		2025-07-02 06:23:29.367	2025-07-02 06:23:29.367				
6c6dfe37-ebff-48b0-8302-2df13ed09f1a	Grand mart			2025-07-02 06:23:44.236	2025-07-02 06:23:44.236				
d1e432ba-bf0b-4439-b548-d7c9e2ce8cf1	Grand mart			2025-07-02 06:23:50.1	2025-07-02 06:23:50.1				
e61283fd-8437-4066-aae1-93f46598708e	Grand mart			2025-07-02 06:48:36.46	2025-07-02 06:48:36.46				
27bf91bb-eb45-4ba4-8502-8a1146c2a22e	Grand mart			2025-07-02 06:48:53.739	2025-07-02 06:48:53.739				
53e69e14-c6dd-4b63-8ee9-ca4b4a6257b2	Grand mart			2025-07-02 06:49:19.04	2025-07-02 06:49:19.04				
ec5ada02-23a3-492b-a681-f957c92e4950	Grand mart			2025-07-02 06:49:34.759	2025-07-02 06:49:34.759				
f5e299ee-dc01-49f2-80a8-efec0653fb78	Tierra Cafe 	551553795		2025-07-02 07:24:06.582	2025-07-02 07:24:06.582		CN-4547944		
d206953f-4a0c-4d79-a5bf-2060e80ed47f	Tierra Cafe	0551553795		2025-07-02 07:25:03.879	2025-07-02 07:25:03.879		CN-4547944		
99eb2809-0489-4ba2-aa8a-81a06ff540d2	Tierra Cafe	506120118		2025-07-02 07:25:53.445	2025-07-02 07:25:53.445		CN-4547944		
5d590a59-ff90-422e-99d1-150dbcbe308d	Harees restaurant	0566178772		2025-07-02 07:36:40.046	2025-07-02 07:36:40.046				
ed6221f6-5017-4c25-a2b5-1c1020ca64b0	Harees restaurant	0566178772		2025-07-02 07:36:43.613	2025-07-02 07:36:43.613				
a8f758d2-7499-4a51-848a-c4188b4c26f3	Mulhem Restaurant	55 587 7611		2025-07-02 07:37:20.95	2025-07-02 07:37:20.95				
bf24b885-7b6f-409f-b845-f3b81248bf7a	Mulhem Restaurant	0555877611		2025-07-02 07:37:45.19	2025-07-02 07:37:45.19				
fe41ea65-86fa-41ef-ba19-bf8e6b757ef3	Mulhem Restaurant	0555877611		2025-07-02 07:38:04.207	2025-07-02 07:38:04.207				
bcb560b0-989e-4e0d-bede-ebe62cdac198	farsana			2025-07-02 07:46:56.647	2025-07-02 07:46:56.647				
b754a27c-daa4-4102-9892-e2da48ef48fd	farsana			2025-07-02 07:47:10.779	2025-07-02 07:47:10.779				
c74fe346-a2aa-48ec-8b96-15d1d80677e0	farsana			2025-07-02 07:47:23.231	2025-07-02 07:47:23.231				
ff366032-dbd0-42ed-a612-36d052a61f67	farsana			2025-07-02 07:47:40.215	2025-07-02 07:47:40.215				
8be8d706-0665-4ae5-ab89-35d7f5d489a5	farsana			2025-07-02 07:47:54.105	2025-07-02 07:47:54.105				
c7ea1a10-c6a7-486d-aacf-de7b8d4b6261	farsana			2025-07-02 07:48:04.921	2025-07-02 07:48:04.921				
cae9d0f4-9603-41e2-97a2-2672d62ddaa4	Helal Al ain Cafeteria\t	559268184		2025-07-02 08:32:34.662	2025-07-02 08:32:34.662				
4f957731-ca4b-4ae4-bbb4-6c8d1a63e7bf	Helal Al ain Cafeteria\t	559268184		2025-07-02 08:32:59.807	2025-07-02 08:32:59.807				
77773ce6-aab4-4ac6-b315-d44ad0676388	Helal Al ain Cafeteria\t	559268184		2025-07-02 08:33:10.591	2025-07-02 08:33:10.591				
e9d73c31-873c-44d3-a7ec-7b91ca5aa66f	Café Kudumbasree Restaurant\t	505135256		2025-07-02 09:42:12.273	2025-07-02 09:42:12.273		CN-5620421		
ee0c2773-096b-4805-81e2-50194f38cdfc	Café Kudumbasree Restaurant\t	505135256		2025-07-02 09:42:17.666	2025-07-02 09:42:17.666		CN-5620421		
a6597399-c232-47aa-b506-c8f5191ead54	Café Kudumbasree Restaurant	0505135256		2025-07-02 09:43:24.832	2025-07-02 09:43:24.832		CN-5620421		
a4b83cca-1f1b-4424-b266-e1792347681d	Café Kudumbasree Restaurant	0505135256		2025-07-02 09:43:47.064	2025-07-02 09:43:47.064				
fea613b1-7816-4faf-9e6c-8492ff16ef77	Café Kudumbasree Restaurant	0505135256		2025-07-02 09:43:53.397	2025-07-02 09:43:53.397		CN-5620421		
f8abaf1b-e58b-4be5-90e5-f86eeac82128	Café Kudumbasree Restaurant	0505135256		2025-07-02 09:43:57.378	2025-07-02 09:43:57.378		CN-5620421		
5b833d96-204a-4938-a95d-968312941f56	Café Kudumbasree Restaurant	0505135256		2025-07-02 09:46:16.415	2025-07-02 09:46:16.415		CN-5620421		
6ff20996-a5cf-4184-baf4-ef770d5185ef	Café Kudumbasree Restaurant	0505135256		2025-07-02 09:47:42.916	2025-07-02 09:47:42.916		CN-5620421		
cc68db85-f8c1-4080-9776-da37a5a531ec	Café Kudumbasree Restaurant\t	505135256		2025-07-02 09:48:41.368	2025-07-02 09:48:41.368		CN-5620421		
8f8cbd37-4649-4d69-969b-fbde29d9b72b	BTWN Restaurants and Coffee			2025-07-03 03:55:29.081	2025-07-03 03:55:29.081		CN-5847820		
6edf0578-0a4d-4768-a9ed-c1c391d3dac7	BTWN Restaurants and Coffee			2025-07-03 03:55:35.374	2025-07-03 03:55:35.374		CN-5847820		
245d075a-d2bf-4145-b9f6-f472cc83ae8f	BTWN Restaurants and Coffee			2025-07-03 03:59:48.217	2025-07-03 03:59:48.217				
a0e10b65-64bf-4f55-b147-3cf9f75f0b18	Café Kudumbasree Restaurant\t	505135256		2025-07-03 04:13:26.08	2025-07-03 04:13:26.08		CN-5620421		
25f0521d-7471-4207-aece-b49b2b3f4d0f	Best Biriyani Restaurant\t	 50 913 2332		2025-07-03 04:18:19.418	2025-07-03 04:18:19.418		CN-2782694		
02bd0f79-22be-4667-b5f9-0198c04aee6a	Best Biriyani Restaurant\t	 50 913 2332		2025-07-03 04:21:55.067	2025-07-03 04:21:55.067		CN-2782694		
c201b1ca-ea9f-48e8-8c9a-81ebc47560c5	Lazord Café \t	54 742 7607		2025-07-03 04:24:18.044	2025-07-03 04:24:18.044		CN-1031379		
e3b0d975-808f-4dd8-b442-415021194a32	Al Falah South			2025-07-03 04:28:03.331	2025-07-03 04:28:03.331				
e2327107-bdef-4a96-bbba-e8b45b19c981	Al Falah West 			2025-07-03 04:28:36.701	2025-07-03 04:28:36.701				
6b1242a0-249a-45c5-819d-39c63f2e3882	Adnoc Shakhbout			2025-07-03 04:29:16.727	2025-07-03 04:29:16.727				
ef5be483-cf87-4cee-97f8-022901c8c168	Baniyas Coop			2025-07-03 04:30:03.498	2025-07-03 04:30:03.498				
105add0e-ba12-4bed-97f1-9a47040d48ff	Bawabat Al sharq Mall			2025-07-03 04:30:44.518	2025-07-03 04:30:44.518				
53d4c8f1-207b-4925-88a8-bca522bce2d9	Zad Catering 			2025-07-03 04:30:51.503	2025-07-03 04:30:51.503		CN-2837838		
a6f05f62-dd7b-46ae-96c9-44878618b793	Baniyas Coop			2025-07-03 04:31:02.466	2025-07-03 04:31:02.466				
238f9c14-5660-423e-9429-7ccd366b8d2b	Bawabat Al sharq Mall			2025-07-03 04:31:17.641	2025-07-03 04:31:17.641				
9b421202-377e-4036-b6f5-0de837af685f	Makani Mall			2025-07-03 04:31:49.465	2025-07-03 04:31:49.465				
0140b88d-ae44-49e7-a875-71af078be9aa	Adnoc Khalifa City North			2025-07-03 04:32:44.144	2025-07-03 04:32:44.144				
69a048d3-c4e8-406c-a76d-3b96542c6904	Adnoc Khalifa City North			2025-07-03 04:33:12.635	2025-07-03 04:33:12.635				
a2067b4e-d252-465c-8404-6a270a09dbe3	Zad Alkhair Catering Services\t			2025-07-03 04:33:51.981	2025-07-03 04:33:51.981		CN-2837838		
9aa30b56-1893-43f9-b846-57b578c85586	Masdar city center			2025-07-03 04:34:11.535	2025-07-03 04:34:11.535				
51f712c6-cc9d-4aef-99a9-0d65dba7ef28	Adnoc al Bahia 			2025-07-03 04:34:56.413	2025-07-03 04:34:56.413				
33962b7d-dd5b-4326-8b8a-f9fbdf98fb80	Adnoc al Bahia 			2025-07-03 04:35:06.835	2025-07-03 04:35:06.835				
baa2d74f-d8c3-4638-8cd5-309c4451f521	Adnoc al Bahia 			2025-07-03 04:35:45.53	2025-07-03 04:35:45.53				
fde686a6-db05-40ea-9721-c5282e411ce7	Adnoc al Bahia 			2025-07-03 04:36:01.92	2025-07-03 04:36:01.92				
6c385d93-7928-4d05-9673-eaabb6bba3f1	Al seef village mall			2025-07-03 04:36:33.42	2025-07-03 04:36:33.42				
e1a980a1-db05-4c9f-a674-f850f586abc1	Al seef village mall			2025-07-03 04:36:39.639	2025-07-03 04:36:39.639				
3e60ac2a-7038-4d2f-9087-c6f45dbe1ccf	Adnoc Samha			2025-07-03 04:37:17.637	2025-07-03 04:37:17.637				
600464ab-85d7-4d3d-ab2d-309cb0b2546d	Adnoc Samha			2025-07-03 04:37:34.266	2025-07-03 04:37:34.266				
b96d73fc-168b-4fd4-9914-4be3bbed1db8	Al Qadhi Shaabi Restaurant \t	0564233660		2025-07-03 04:39:03.73	2025-07-03 04:39:03.73		CN-1122662		
e9dfbedf-f2f6-42c5-a6af-91412853c61f	Adnoc Samha			2025-07-03 04:39:31.49	2025-07-03 04:39:31.49				
c926b250-7156-4994-a41c-826b067e75e2	Adnoc Mahawi			2025-07-03 04:40:09.709	2025-07-03 04:40:09.709				
464ff129-1a2b-4079-ab0e-9b25ee814157	Yas Mall			2025-07-03 04:40:49.475	2025-07-03 04:40:49.475				
04cbd2e5-edf3-4d5e-8126-b9445be31943	veg shop	50231 1260		2025-07-03 05:01:43.491	2025-07-03 05:01:43.491				
4ff86f14-4b6a-48c6-bf52-9b9e0a4f525d	veg shop			2025-07-03 05:01:56.097	2025-07-03 05:01:56.097				
5b565d34-275a-4a69-8346-e86090aa2a44	Al Falah West 			2025-07-03 05:22:04.065	2025-07-03 05:22:04.065				
de77068d-e07b-4142-8ceb-b16a42873de6	Adnoc Shakhbout			2025-07-03 05:22:30.541	2025-07-03 05:22:30.541				
c34cdfc2-b730-41b4-90e6-a02adf34657c	Baniyas Coop			2025-07-03 05:22:57.874	2025-07-03 05:22:57.874				
caf76ea4-9c99-4c9b-89ad-5296822351b7	Peshawari Food Restaurant \t	562464045    		2025-07-03 05:26:26.023	2025-07-03 05:26:26.023		CN-5489476		
b1f51daf-1ade-49e3-b2aa-ac4686a5804e	Makani Mall			2025-07-03 05:26:58.628	2025-07-03 05:26:58.628				
1ade60ce-ee52-4ac1-95ed-5b3b07364585	Adnoc Khalifa City North			2025-07-03 05:27:08.936	2025-07-03 05:27:08.936				
e7c8bebb-2e0f-43c1-a016-6f61489ae2e3	Adnoc al Bahia 			2025-07-03 05:27:58.063	2025-07-03 05:27:58.063				
b057dc6b-4858-4b75-b667-f8347e2ca26f	Peshawari Food Restaurant \t	562464045    		2025-07-03 05:30:28.736	2025-07-03 05:30:28.736		CN-5489476		
c8fe266e-3c4b-4c39-9d1c-9910050afaac	Tamntinou Sweets 			2025-07-03 05:34:16.135	2025-07-03 05:34:16.135		CN-5377234		
393e6c59-08ea-4190-b0cf-a43cb9695471	Sofra Baniyas Restaurant\t	56 352 3882		2025-07-03 05:36:40.251	2025-07-03 05:36:40.251		CN-5130721		
31bf8be1-4805-49bb-b47a-fc815ff2ae12	Strorage 			2025-07-03 05:47:35.041	2025-07-03 05:47:35.041		CN-2326925		
f6e91044-6b50-4932-b005-838bf1761c46	Corniche 			2025-07-03 05:49:13.952	2025-07-03 05:49:13.952		CN-1176665		
728cb02f-aca7-40d8-b5fe-4a0137818ca1	Corniche 			2025-07-03 05:50:01.533	2025-07-03 05:50:01.533		CN-1176665		
da007629-25ae-483a-bdc9-14e3a540ae6d	BTWN Restaurants and Coffee			2025-07-03 05:50:28.164	2025-07-03 05:50:28.164		CN-5847820		
aa012264-16c4-4867-b122-b36c1a422f09	Bounce 			2025-07-03 05:56:08.54	2025-07-03 05:56:08.54				
44fb1144-8258-4ff7-9d95-92165fa68e42	Bounce 			2025-07-03 05:56:31.241	2025-07-03 05:56:31.241				
bb3dc792-4008-4cfc-9ac1-42a29f809d80	Sushi House 			2025-07-03 05:57:03.451	2025-07-03 05:57:03.451		CN-4004955		
4f223f59-1ad3-4583-bea9-ce9cce079aa1	Sushi House 			2025-07-03 05:57:47.248	2025-07-03 05:57:47.248		CN-4004955		
086915cc-7086-43ca-8be1-0cc8a913dad9	Bedashing Beauty Lounge	0526906974		2025-07-03 06:05:41.934	2025-07-03 06:05:41.934	Ramsheed	CN-1147789		
e8aced27-d4d8-4fc9-959f-4113cd3ecf65	Yas Mall			2025-07-03 06:21:13.476	2025-07-03 06:21:13.476				
c6def147-bb5b-49ea-8b93-ee7fe08239d7	Al Falah West 			2025-07-03 06:22:35.901	2025-07-03 06:22:35.901		CN-5843646		
20baba12-4977-4b00-abf2-a90464cb676d	Adnoc Khalifa City North			2025-07-03 06:23:55.258	2025-07-03 06:23:55.258		CN-5843646		
5e306eb8-ca53-4803-8e9f-aee51d8538cc	World Trade Center 			2025-07-03 06:24:37.813	2025-07-03 06:24:37.813		CN-1031673-40		
192859d2-ec50-4ac8-a017-6098d88fbb9e	Deerfields Mall			2025-07-03 06:26:16.585	2025-07-03 06:26:16.585		CN-4823843		
cc56b9ec-d5f7-4358-ae4f-d58f5eb029db	Deerfields Mall			2025-07-03 06:26:21.873	2025-07-03 06:26:21.873		CN-4823843		
6fb78c15-41f9-432d-83cf-b743d2d1e5bf	Masdar city center			2025-07-03 06:27:21.811	2025-07-03 06:27:21.811		CN-1031673-56		
77b42fd1-060a-456a-95f0-679f69e2d628	Adnoc Samha			2025-07-03 06:28:34.498	2025-07-03 06:28:34.498		CN-5420778		
b0b488d8-f66e-42e5-b3a5-ac4189be28b4	Adnoc Samha			2025-07-03 06:28:47.803	2025-07-03 06:28:47.803		CN-5420778		
9f05e154-eb82-403a-b244-126c03246b29	Adnoc Samha			2025-07-03 06:28:55.875	2025-07-03 06:28:55.875		CN-5420778		
09442fe5-ffa3-4d74-b2f5-44b0c0b4232c	Adnoc Samha			2025-07-03 06:29:44.456	2025-07-03 06:29:44.456		CN-5420778		
687714b3-ceab-41f2-9479-e0e5dc703ec7	Adnoc Embassies Area			2025-07-03 06:30:47.245	2025-07-03 06:30:47.245		CN-1031673-16		
102deaa2-2455-47c9-b76e-68c54baa9aa7	Adnoc Tamouh 			2025-07-03 06:32:26.063	2025-07-03 06:32:26.063		CN-2779104		
a807da42-965f-4b32-b216-27ea8b4c523b	Adnoc al Bahia 			2025-07-03 06:33:17.363	2025-07-03 06:33:17.363		CN-1031673-50		
c73dae09-e004-46d4-b9d8-3c0b7b82d00a	Al Qadhi Shaabi Restaurant \t	0564233660		2025-07-03 06:35:07.815	2025-07-03 06:35:07.815		CN-1122662		
1bb6571c-8be8-4053-8a96-15657fb03f52	Bangla Baraka Restaurant 	543902032		2025-07-03 06:35:46.692	2025-07-03 06:35:46.692		CN-1125545		
cbbaa60d-3607-4547-b7b6-513b8f4d7e41	Adnoc al Bahia 			2025-07-03 06:38:09.409	2025-07-03 06:38:09.409		CN-1031673-50		
549243a3-7e66-4157-b29d-0b696e463d77	Aldalwo Alfedi Food stuff Trading	569240790		2025-07-03 06:38:26.956	2025-07-03 06:38:26.956		CN-1152773		
5a912f8f-77ef-46a8-92e0-b7827d008f54	Aldalwo Alfedi Food stuff Trading	569240790		2025-07-03 06:38:31.557	2025-07-03 06:38:31.557		CN-1152773		
f123e933-8716-4e4d-a594-495500062f8f	Aldalwo Alfedi Food stuff Trading	569240790		2025-07-03 06:38:35.176	2025-07-03 06:38:35.176		CN-1152773		
069ba0a8-1bd0-4570-80be-3208c307f5be	World Trade Center 			2025-07-03 06:38:50.013	2025-07-03 06:38:50.013		CN-1031673-40		
674ea7b9-213a-40f7-8297-2e376db1cfdb	Masdar city center			2025-07-03 06:39:12.931	2025-07-03 06:39:12.931		CN-1031673-56		
36babcd1-0f9d-4690-8b28-e3d9a7124957	Adnoc Embassies Area			2025-07-03 06:39:21.453	2025-07-03 06:39:21.453		CN-1031673-16		
7c0650de-20f4-42fc-989c-bcd2766eb732	Adnoc Embassies Area			2025-07-03 06:39:37.729	2025-07-03 06:39:37.729		CN-1031673-16		
a34c39fc-f081-4ef7-a782-2d5d4f040bd5	Aldalwo Alfedi Food stuff Trading	569240790		2025-07-03 06:39:38.052	2025-07-03 06:39:38.052		CN-1152773		
5c5b5c93-01ee-4f5b-bb56-8ab58447752b	Mulhem Restaurant	0555877611		2025-07-03 06:49:50.739	2025-07-03 06:49:50.739				
14591437-5117-443e-87a9-f0616bee773f	Mulhem Restaurant	0555877611		2025-07-03 06:50:39.566	2025-07-03 06:50:39.566				
c4d8547c-b16b-4346-81a3-84dd00f54dc0	Mulhem Restaurant	0555877611		2025-07-03 06:50:42.379	2025-07-03 06:50:42.379				
61952475-8b12-46b9-8456-da3fb737fb7d	Bedashing Beauty Lounge	0526906974		2025-07-03 07:09:21.708	2025-07-03 07:09:21.708	Ramsheed	CN-1147789		
1e3ca798-5b1d-4358-8081-9466bb4cda4d	Wood House Restaurant			2025-07-03 07:12:05.077	2025-07-03 07:12:05.077		CN-2802330		
ebda5b7a-1dbc-4352-bcd3-6da16681386b	Wood House Restaurant			2025-07-03 07:12:13.187	2025-07-03 07:12:13.187		CN-2802330		
5c69acca-6091-47cf-9de7-2facfacda9e2	Wood House Restaurant			2025-07-03 07:12:40.608	2025-07-03 07:12:40.608		CN-2802330		
6f073475-8507-46a7-9411-d5a3635bc104	Wood House Restaurant			2025-07-03 07:12:47.32	2025-07-03 07:12:47.32		CN-2802330		
6da4adad-7136-4a13-bf2b-4395a9fdc35e	arabic	8930		2025-07-03 07:21:38.99	2025-07-03 07:21:38.99				
1823dc9a-c4ab-4e30-bbdd-72cdba02fe29	Al Noor Modern Bakery			2025-07-03 07:21:56.195	2025-07-03 07:21:56.195				
e750d3fa-4fa2-4510-b2ce-dc3d4b2acdf6	Wood House Restaurant\t			2025-07-03 07:22:10.323	2025-07-03 07:22:10.323				
d91ce347-be3d-4806-9302-2bbffe8e4e01	Saraya Halab Restaurant	521333749		2025-07-03 07:23:07.439	2025-07-03 07:23:07.439		CN-2845620		
07a36db2-6fce-4322-8b95-f3d5a09abbf6	Saraya Halab Restaurant	521333749		2025-07-03 07:23:25.246	2025-07-03 07:23:25.246		CN-2845620		
622e6827-79a0-4857-9741-3f637c46afa3	Saraya Halab Restaurant	521333749		2025-07-03 07:48:41.559	2025-07-03 07:48:41.559		CN-2845620		
c7e99dc8-a790-4f3c-abca-3f696467c3f3	Saraya Halab Restaurant	521333749		2025-07-03 07:49:08.777	2025-07-03 07:49:08.777		CN-2845620		
adc03f01-d828-45d4-b7d4-a7282f9ad37f	Saraya Halab Restaurant	521333749		2025-07-03 07:49:14.239	2025-07-03 07:49:14.239		CN-2845620		
f8bd6748-fd7b-42f6-a242-8bb6f168285a	Saraya Halab Restaurant	521333749		2025-07-03 07:49:18.069	2025-07-03 07:49:18.069		CN-2845620		
c4f2923c-c92f-426c-9e35-23a76f40ebf8	Eagle Environmental Services and Pest Control 	0564106029	bachir@eagle-enviro.ae	2025-07-03 08:14:48.563	2025-07-03 08:14:48.563	Bachir Hussein		Administration Supervisor – Lot 2	024481500   
a4d24152-b921-4828-823d-81edd928a0fd	Harees  Al Majlis Traditional Food	0506383660		2025-07-03 11:49:32.709	2025-07-03 11:49:32.709				
70f302d9-b7eb-4a1d-833f-8d0c478b54ae	Harees  Al Majlis Traditional Food			2025-07-03 11:53:54.179	2025-07-03 11:53:54.179				
630855b2-07d7-4398-bbdb-7c74ad8ba1d3	farsa			2025-07-03 11:55:33.357	2025-07-03 11:55:33.357				
0f15e299-9b83-435e-8e92-0d84e56262d5	diet station			2025-07-03 12:54:04.206	2025-07-03 12:54:04.206				
46f560fc-bd3c-437b-9263-41ea550bba55	Gotahan Ok Nato Restaurant			2025-07-04 04:35:59.886	2025-07-04 04:35:59.886		CN-5852420		
9e8b8172-98b3-4e2d-a47c-722045135739	Oxygen Restaurant 			2025-07-04 04:53:48.513	2025-07-04 04:53:48.513				
8874b7de-f13b-4678-aa23-e4353a419658	BTWN Restaurants and Coffee			2025-07-04 04:54:49.604	2025-07-04 04:54:49.604		CN-5847820		
bd113a5f-9785-483d-88ac-60aad4de5319	BTWN Restaurants and Coffee			2025-07-04 04:55:21.148	2025-07-04 04:55:21.148		CN-5847820		
a9f7e02d-4c8d-4796-9993-48910055a64a	Oxygen Restaurant 			2025-07-04 05:02:40.739	2025-07-04 05:02:40.739				
84e99f0c-c4b0-4bf7-870e-16be74abeb00	Oxygen Restaurant 			2025-07-04 05:04:13.341	2025-07-04 05:04:13.341				
228ff735-1886-45d0-b5ad-48fbad7d72ae	Oxygen Restaurant 			2025-07-04 05:05:22.528	2025-07-04 05:05:22.528				
f0adcb4d-e6d7-48df-91e2-3b518fe2b8ce	Oxygen Restaurant 			2025-07-04 05:06:20.605	2025-07-04 05:06:20.605				
24ecbc9b-f911-47c7-9469-ad75a8da8b12	Oxygen Restaurant 			2025-07-04 05:08:17.467	2025-07-04 05:08:17.467				
1451bd0a-1f12-4713-b24e-81c82b2feb19	Oxygen Restaurant 			2025-07-04 05:09:23.454	2025-07-04 05:09:23.454				
48899022-3fd6-400c-a7f3-7f3c43d42425	Oxygen Restaurant 			2025-07-04 05:09:30.25	2025-07-04 05:09:30.25				
f7b38dc0-9d42-4074-910e-9a37e7c36f52	Oxygen Restaurant 			2025-07-04 05:11:05.947	2025-07-04 05:11:05.947				
bf4233c7-049d-4824-a0ab-7c908a16728f	Oxygen Restaurant 			2025-07-04 05:12:34.064	2025-07-04 05:12:34.064				
772fe6ba-1aea-49f7-819e-3a6ba38c547c	Oxygen Restaurant 			2025-07-04 05:13:54.979	2025-07-04 05:13:54.979				
b2f5182e-0ffc-4b72-a4d8-f2df383a40d1	Diet Station Restaurant			2025-07-04 05:40:18.678	2025-07-04 05:40:18.678		CN-2184146		
2c6a5da8-78fb-4ed1-814a-a5652cc2016b	Diet Station Restaurant			2025-07-04 05:40:22.671	2025-07-04 05:40:22.671		CN-2184146		
3256c39b-20a6-4843-866b-a0a141d52948	On the Block Cafe	507432157    		2025-07-04 05:41:46.697	2025-07-04 05:41:46.697		CN-5825141		
828f6933-cdd9-492c-9622-7fcebdac43db	Self-IML			2025-07-04 05:42:28.177	2025-07-04 05:42:28.177				
2d113164-cc8e-4377-a273-053fa6421421	Feather Cafe	507930741		2025-07-04 05:42:54.253	2025-07-04 05:42:54.253		CN-4353809		
ee580943-e046-418d-bf2e-28977b591f7d	Harees Alfarej Restaurant \t	0506383660		2025-07-04 05:44:10.849	2025-07-04 05:44:10.849		CN-5741845		
1cf019b7-0792-4534-8caf-30575421a58e	Harees Alfarej Restaurant \t	0506383660		2025-07-04 05:44:29.18	2025-07-04 05:44:29.18				
1f3061c4-b285-41d4-9020-d190b7b8289e	alwan grocery 	 58 672 1321		2025-07-04 06:05:05.945	2025-07-04 06:05:05.945				
bd3be823-ad39-42c6-9c25-f38ade1b7f0a	km trading			2025-07-04 06:06:18.702	2025-07-04 06:06:18.702				
3c1cc152-52da-4aaf-b595-968549b42e67	km trading			2025-07-04 06:06:32.243	2025-07-04 06:06:32.243				
c127f4a8-4b1b-476a-a92f-0df381142290	Oxygen Restaurant 			2025-07-04 06:10:44.518	2025-07-04 06:10:44.518		CN-5910671		
fab79666-f5e8-42c4-8f56-cd8be039cd10	Harees Alfarej Restaurant \t	0506383660		2025-07-04 07:52:10.096	2025-07-04 07:52:10.096				
528e736f-6cc0-4099-8b2b-3acf668421c8	Harees Alfarej Restaurant \t	0506383660		2025-07-04 07:53:19.971	2025-07-04 07:53:19.971		CN-5741845		
6282140f-1e8e-4988-bd50-59c4c9f585c7	Harees Alfarej Restaurant \t	0506383660		2025-07-04 07:53:25.517	2025-07-04 07:53:25.517		CN-5741845		
86bbcd0b-4cb2-445f-9cef-ca1e7bff6dda	Restaurant	50 909 3676		2025-07-04 08:06:07.579	2025-07-04 08:06:07.579				
862ab99a-1f41-4454-bf6b-d100e3decd58	Harees  Al Majlis Traditional Food			2025-07-04 08:08:18.648	2025-07-04 08:08:18.648				
362dfbd1-7e91-4784-b0b5-5dc21c4a633a	Restaurant	50 812 0864		2025-07-04 08:12:57.045	2025-07-04 08:12:57.045				
901a7635-fda1-4264-acc1-4d82bf60d155	Golden Dalla Meals			2025-07-04 08:15:23.85	2025-07-04 08:15:23.85		CN-1530789		
aef3861f-2c79-4ce2-978f-abce483b770d	Golden Dalla Meals			2025-07-04 08:16:09.771	2025-07-04 08:16:09.771		CN-1530789		
c609a215-57a8-4150-a989-e4db648fda33	Golden Dalla Meals			2025-07-04 08:16:36.943	2025-07-04 08:16:36.943		CN-1530789		
d2380a89-2a5c-4222-bb82-e999236c7e0a	Butchery Bestiame			2025-07-04 08:25:00.049	2025-07-04 08:25:00.049		CN-1530789		
7a77bb62-0278-481c-941d-81f36c8b5c5b	Modern Mood General Trading 			2025-07-04 08:27:09.029	2025-07-04 08:27:09.029		CN-5587645		
72998b65-6be1-4f88-93cc-9bf7077676c6	Modern Mood General Trading 			2025-07-04 08:27:35.988	2025-07-04 08:27:35.988				
0a9db6cb-ec6c-44b3-8d0c-f9cde33d4bbd	Modern Mood General Trading 			2025-07-04 08:27:40.893	2025-07-04 08:27:40.893				
d09e793a-038a-49e2-b688-6b22285c928f	Your Destination for Juices 			2025-07-04 08:29:47.794	2025-07-04 08:29:47.794		CN-3941779		
3cb7cf12-83f6-481e-b6c8-d04722874b10	Your Destination for Juices 			2025-07-04 08:30:00.322	2025-07-04 08:30:00.322		CN-3941779		
6aeb2765-9838-4cdd-858e-3ce9616b2461	Your Destination for Juices 			2025-07-04 08:30:06.05	2025-07-04 08:30:06.05		CN-3941779		
5c8a0f3b-98f1-42c9-83ed-aafc8c3a405f	Trio cafe	8894		2025-07-04 08:37:56.132	2025-07-04 08:37:56.132				
f41dcec6-749f-4668-a309-190dae605cd2	Your Destination for Juices 			2025-07-04 08:38:24.653	2025-07-04 08:38:24.653		CN-3941779		
4d93101e-a2a5-4d27-83df-5a73d912db28	Your Destination for Juices 			2025-07-04 08:38:30.889	2025-07-04 08:38:30.889		CN-3941779		
b6dbc1c2-d354-4c45-a4f7-3144f164778d	Your Destination for Juices 			2025-07-04 08:38:41.3	2025-07-04 08:38:41.3		CN-3941779		
58f11666-6803-4aa2-8745-85ccad0f5f9b	Your Destination for Juices 			2025-07-04 08:38:47.102	2025-07-04 08:38:47.102		CN-3941779		
3fd16529-300f-433c-9c88-fb2ac9518588	Tineh and Zaitoneh For Foodstuff 			2025-07-04 08:40:18.175	2025-07-04 08:40:18.175		CN-2872056		
b3d5bb6a-8343-4882-be01-999bb75d34c7	Tineh and Zaitoneh For Foodstuff 			2025-07-04 08:40:49.796	2025-07-04 08:40:49.796				
cbca6384-16fc-4063-992a-a88f6522024a	Tineh and Zaitoneh For Foodstuff 			2025-07-04 08:40:55.414	2025-07-04 08:40:55.414				
e41caa21-7865-4995-875d-57591e776735	Tineh and Zaitoneh For Foodstuff 			2025-07-04 08:41:18.016	2025-07-04 08:41:18.016				
3d529acb-7083-4f99-b9f2-bc09f181c651	Tineh and Zaitoneh For Foodstuff 			2025-07-04 08:41:22.971	2025-07-04 08:41:22.971				
3a5cb6b5-9ea9-40aa-8da4-785c2c8392cc	Modern Mood General Trading 			2025-07-04 08:43:41.169	2025-07-04 08:43:41.169		CN-5587645		
b2969f0c-ed86-40e0-837e-8acf6180bc3e	Modern Mood General Trading 			2025-07-04 08:43:45.527	2025-07-04 08:43:45.527		CN-5587645		
01ed33d7-af9b-4c03-8869-53276f7f76ba	Modern Mood General Trading 			2025-07-04 08:44:01.594	2025-07-04 08:44:01.594		CN-5587645		
2f15a5c8-4ea9-48eb-912f-34941ce6a40d	Modern Mood General Trading 			2025-07-04 08:44:06.827	2025-07-04 08:44:06.827		CN-5587645		
4732ca6d-b40e-4683-93df-b5afc83681a6	Modern Mood General Trading 			2025-07-04 08:44:11.671	2025-07-04 08:44:11.671		CN-5587645		
621e661f-7f23-4d3f-97ee-4431fb1b522a	Your Destination for Juices 			2025-07-04 08:44:46.816	2025-07-04 08:44:46.816				
81c68035-22b9-42a3-b18f-719a1ad0403f	Your Destination for Juices 			2025-07-04 08:44:52.391	2025-07-04 08:44:52.391				
aebef1cd-d9e6-4b8c-bc01-6faa630321b4	Tineh and Zaitoneh For Foodstuff 			2025-07-04 08:45:08.052	2025-07-04 08:45:08.052				
7d71dc97-a971-4c58-af26-01e3c1291a90	Tineh and Zaitoneh For Foodstuff 			2025-07-04 08:45:17.786	2025-07-04 08:45:17.786				
3b944179-aec9-405a-b861-6a6c3863d942	Tineh and Zaitoneh For Foodstuff 			2025-07-04 08:46:20.7	2025-07-04 08:46:20.7		CN-2872056		
5afdb776-b1be-4020-a995-fad90d1f27ab	Tineh and Zaitoneh For Foodstuff 			2025-07-04 08:46:26.882	2025-07-04 08:46:26.882		CN-2872056		
b10ce9b0-745e-4d65-bdf3-42917e182ac4	Tineh and Zaitoneh For Foodstuff 			2025-07-04 08:46:41.225	2025-07-04 08:46:41.225		CN-2872056		
8dcd71d6-101e-4906-a0e8-317daffaa88b	Tineh and Zaitoneh For Foodstuff 			2025-07-04 08:46:46.823	2025-07-04 08:46:46.823		CN-2872056		
789c7c64-acae-4f2b-a7be-e42deae1551c	Al Sadu Mandi Restaurant			2025-07-04 09:03:47.825	2025-07-04 09:03:47.825		CN-2816246		
1ba3fa5f-0504-4e96-af3e-df6963e4c6a7	Crystal Diamond Restaurant\t	50 812 0864		2025-07-04 09:05:06.903	2025-07-04 09:05:06.903				
23634b2a-80ec-4d98-bb46-65149e0fdd54	Crystal Diamond Restaurant\t	50 812 0864		2025-07-04 09:05:20.965	2025-07-04 09:05:20.965				
c6effd6d-a750-49c3-93d5-b87693b3d966	Delicace Boutique	56 331 1242		2025-07-04 09:33:26.618	2025-07-04 09:33:26.618				
3bfb1e8f-feb0-4621-b99d-b30435a60f14	Lulu Al Sahra Food Stuff Stores L.L.C\t	56 964 2465		2025-07-04 09:34:20.97	2025-07-04 09:34:20.97				
2cf4cb9c-1dba-4226-b77b-7fe2d0a50fa6	Baqala	55 137 5732		2025-07-04 09:34:26.343	2025-07-04 09:34:26.343				
5f4e414b-2600-43df-bb25-0f5a16f97be9	Grocery	55 742 3413		2025-07-04 09:34:38.056	2025-07-04 09:34:38.056				
57fa5b8b-d06f-417e-afaa-3f190bd26e36	veg shop	50231 1260		2025-07-04 09:35:12.753	2025-07-04 09:35:12.753				
dcef3160-098b-420c-bd78-bdf1fc7f0906	veg shop			2025-07-04 09:35:25.921	2025-07-04 09:35:25.921				
83982303-85e8-4e60-9d35-505dc00859cb	alwan grocery 	 58 672 1321		2025-07-04 09:35:44.938	2025-07-04 09:35:44.938				
7b53c742-9027-445f-af3c-a3f86dbc0a64	km trading			2025-07-04 09:38:40.865	2025-07-04 09:38:40.865				
86cbf681-4f0b-46e7-8d76-f3b26a531c0d	km trading			2025-07-04 09:38:53.879	2025-07-04 09:38:53.879				
91fe1e2c-8ca5-4907-84dd-4076b16c54d8	Helal Al ain Cafeteria\t	559268184		2025-07-04 09:42:40.078	2025-07-04 09:42:40.078				
448f2a0d-7467-4988-abd4-8be6b3415ec8	Just Break Cafeteria	0502193600		2025-07-04 09:42:55.074	2025-07-04 09:42:55.074				
957b0942-b4bf-4872-9bbe-25372064cda1	Just Break Cafeteria	0502193600		2025-07-04 09:43:02.358	2025-07-04 09:43:02.358				
798754bf-c3ce-4892-9daf-3006871e8c0e	Al YASMEEN CENTER	91 89604 23817		2025-07-04 09:55:04.109	2025-07-04 09:55:04.109				
ac224b19-d6c7-4936-8016-290b3ed50f89	Al phamed	Bashir		2025-07-04 09:58:58.244	2025-07-04 09:58:58.244				
e058697e-5df4-4719-ab17-f50d9fe1f7c8	Al phamed			2025-07-04 09:59:17.066	2025-07-04 09:59:17.066				
8cecb125-9d75-4b4c-9134-f50bbd3db171	Al phamed			2025-07-04 09:59:33.421	2025-07-04 09:59:33.421				
25b4fb27-f06d-402c-8c17-cbff0c137efc	Cro Bakery and Cafe			2025-07-04 10:01:18.924	2025-07-04 10:01:18.924				
348c346d-79be-407d-ad26-f55c86a63231	Cro Bakery and Cafe			2025-07-04 10:01:38.166	2025-07-04 10:01:38.166				
222a312d-6e8c-41d1-b6a0-86384f8c97a7	Cro Bakery and Cafe			2025-07-04 10:01:49.584	2025-07-04 10:01:49.584				
e9c478a6-95a1-4545-8b95-09d553c9240f	Cro Bakery and Cafe			2025-07-04 10:02:00.256	2025-07-04 10:02:00.256				
24601090-dde9-476a-b30f-09621bf7126a	Tierra Cafe	Subin		2025-07-04 10:04:11.177	2025-07-04 10:04:11.177				
5d3cdc4c-f4fb-4a7d-9639-bc801a5ee623	Tierra Cafe	Subin		2025-07-04 10:04:22.338	2025-07-04 10:04:22.338				
6800bc59-c034-4180-912b-f3a22705a090	Tierra Cafe	Subin		2025-07-04 10:04:34.805	2025-07-04 10:04:34.805				
60cd0940-8eea-469f-acc1-4ced2546b440	Tierra Cafe	Subin		2025-07-04 10:04:53.998	2025-07-04 10:04:53.998				
124ebee3-68ac-4f2c-8868-4d82b28934d4	Trio cafe	8894		2025-07-04 10:05:28.045	2025-07-04 10:05:28.045				
30936aac-92b5-4501-a220-b6bd673bf88e	Al Noor Modern Bakery			2025-07-04 10:09:15.385	2025-07-04 10:09:15.385				
35bef8c8-8c26-4543-a7ae-a269678367be	Mandi Flavor Restaurant	50 509 8930		2025-07-04 10:09:57.68	2025-07-04 10:09:57.68				
f6fa5ed6-1f51-463e-b1ab-c98777f83bc5	Tierra Cafe	Subin		2025-07-04 10:10:23.114	2025-07-04 10:10:23.114				
e475e467-ce0e-46da-8f89-401481e49c41	Tierra Cafe	Subin		2025-07-04 10:10:26.755	2025-07-04 10:10:26.755				
f3056a3c-8417-404d-beeb-5c6b9ee20405	Tierra Cafe	Subin		2025-07-04 10:10:30.759	2025-07-04 10:10:30.759				
54413186-00c6-48ea-92e3-4a56ed35d298	Trio cafe	8894		2025-07-04 10:10:36.645	2025-07-04 10:10:36.645				
b8a5044a-c442-43d1-9feb-c94212602ace	Mandi Flavor Restaurant	50 509 8930		2025-07-04 10:11:08.518	2025-07-04 10:11:08.518				
bf3f5b6e-3566-4032-b41b-db347bd08ff8	Dara Grocery	56 784 7211		2025-07-04 11:40:16.694	2025-07-04 11:40:16.694				
ae475fe8-aeca-410b-a621-a6588a9e94f0	Al madeena Fruits and Vegetable shop	50231 1260		2025-07-04 11:41:37.649	2025-07-04 11:41:37.649				
6ec13403-fd21-4c7d-965f-1e60aee300da	Al madeena Fruits and Vegetable shop	50231 1260		2025-07-04 11:41:49.905	2025-07-04 11:41:49.905				
5d6b022f-a9d8-4f4a-9169-c60d80d167d4	Al madeena Fruits and Vegetable shop			2025-07-04 11:42:03.038	2025-07-04 11:42:03.038				
7ddecacb-81ad-40c8-ae6c-f6811d3ebbea	Wahat Al Daher Baqala	55 742 3413		2025-07-04 11:45:04.44	2025-07-04 11:45:04.44				
f57a40b5-feea-48db-bf9e-855ef6044f63	Noor Al Ward Grocery	3413		2025-07-04 11:45:37.925	2025-07-04 11:45:37.925				
3c43a178-3881-4580-9e4a-ed96e56012e2	AL noorain vef and fruits	0504148690		2025-07-04 11:46:08.042	2025-07-04 11:46:08.042				
ae2f98e5-9a68-4123-88d3-085c775930df	Al madeena Fruits and Vegetable shop	50231 1260		2025-07-04 11:46:12.191	2025-07-04 11:46:12.191				
050d8712-6700-4002-8317-bfd838bb7ff1	Al madeena Fruits and Vegetable shop			2025-07-04 11:46:16.041	2025-07-04 11:46:16.041				
aed596db-607f-4421-96ac-b06dee24e7c2	Noor Al Ward Grocery	3413		2025-07-04 11:46:24.399	2025-07-04 11:46:24.399				
4edab08d-b358-4376-a168-e270a6e7d196	km trading			2025-07-04 11:46:38.557	2025-07-04 11:46:38.557				
f5035444-72a5-4e4c-9891-d20492913fa0	km trading			2025-07-04 11:46:56.21	2025-07-04 11:46:56.21				
852b1117-0f24-485a-a429-14e0313e5b4b	km trading			2025-07-04 11:47:13.247	2025-07-04 11:47:13.247				
47b0b9ae-3c03-4e91-b8b7-937ba6dbc100	km trading			2025-07-04 11:47:28.612	2025-07-04 11:47:28.612				
816823a7-3d37-44b4-8f85-40f6b750646a	grocery	5732		2025-07-04 12:13:38.542	2025-07-04 12:13:38.542				
232a5667-1664-4f79-8bdd-7a5e61d4cf24	grocery			2025-07-04 12:13:56.561	2025-07-04 12:13:56.561				
91a790a6-373b-4703-928e-f034a4de8cd3	km trading			2025-07-04 12:14:40.298	2025-07-04 12:14:40.298				
e56cbf37-db52-42a3-8517-0c59292d3144	km  trading			2025-07-04 12:14:50.109	2025-07-04 12:14:50.109				
a4495f24-f176-45a9-a6b1-5465f1b45b46	km trading			2025-07-04 12:14:54.429	2025-07-04 12:14:54.429				
7f318f67-03f7-48a2-802b-a269a672b6c0	km trading			2025-07-04 12:15:03.978	2025-07-04 12:15:03.978				
112b161e-505d-4d39-97e0-39959f26e5c0	km  trading			2025-07-04 12:15:11.208	2025-07-04 12:15:11.208				
38e99674-34de-49d6-8de8-de614d429af1	km trading			2025-07-04 12:15:14.271	2025-07-04 12:15:14.271				
7a005915-670c-4199-9e04-ce158715c6e3	alhor 	rachel		2025-07-04 12:17:23.731	2025-07-04 12:17:23.731				
39190b60-9974-4fa8-b466-3eb128e5b0cb	Al Hor Camping and Hunding Tools\t	rachel		2025-07-04 12:17:39.779	2025-07-04 12:17:39.779				
66daed1f-3bb4-4e98-a4e3-3adb9735825b	Break Time  Cafeteria 			2025-07-05 04:05:51.281	2025-07-05 04:05:51.281		CN-1481871		
0d98d9ab-bc87-4eb4-9875-5a076e370b95	Break Time  Cafeteria 			2025-07-05 04:06:37.908	2025-07-05 04:06:37.908		CN-1481871		
d1c1ae28-09ee-4c0b-8231-f0e5c4cd66fc	Break Time  Cafeteria 			2025-07-05 04:07:32.984	2025-07-05 04:07:32.984		CN-1481871		
6df5b288-f7c0-43d3-8a4d-bf7d1cdd1258	Diet Station Restaurant			2025-07-05 04:08:58.414	2025-07-05 04:08:58.414		CN-2184146		
1ea87120-a550-4439-a27d-c2fc53c5f1cf	Self-IML			2025-07-05 04:10:41.603	2025-07-05 04:10:41.603				
eba1e5ef-8d39-498b-8ae3-2b93e1156ece	Piece of Café\t	0569238807		2025-07-05 04:12:52.92	2025-07-05 04:12:52.92		CN-4601105		
0c562858-31dd-4d97-8a58-24aa7fae7433	Piece of Café\t	0569238807		2025-07-05 04:16:16.925	2025-07-05 04:16:16.925		CN-4601105		
71970b79-e177-4fcf-9a59-9d7819a7496f	Harees Alfarej Restaurant \t	0506383660		2025-07-05 04:17:58.299	2025-07-05 04:17:58.299		CN-5741845		
fc6d566c-54f7-442f-9c20-79d5e04bd250	Golden Kattans Restaurant 			2025-07-05 04:23:13.257	2025-07-05 04:23:13.257		CN-5385864		
fc64f4b6-90d3-4efa-a094-9dff473938d4	Harees Alfarej Restaurant \t	0506383660		2025-07-05 04:26:19.51	2025-07-05 04:26:19.51		CN-5741845		
abd9e587-3b61-4c59-bc2c-5d961b80a928	Typing coffee shop\t	50 541 5399		2025-07-05 04:28:04.09	2025-07-05 04:28:04.09		CN-3815830		
cc677ad9-2913-4a81-a404-0b728f510549	Trio Cafe	0542798894		2025-07-05 04:33:30.492	2025-07-05 04:33:30.492		CN-5122702		
b4d023e7-1d93-448e-93df-ef020386247c	Feather Cafe	507930741		2025-07-05 04:38:21.623	2025-07-05 04:38:21.623		CN-4353809		
171b7a78-ed7a-43b8-88dc-15cf208cb608	Chicken Street			2025-07-05 04:40:38.704	2025-07-05 04:40:38.704		CN-2342478		
79e8412d-52a3-4a1e-aa20-0c17edb79125	Feather Café \t	0507930741		2025-07-05 04:41:42.568	2025-07-05 04:41:42.568		CN-4353809		
f197cffe-cb0b-4764-8a05-a3300e44d11f	Chicken Street			2025-07-05 04:42:07.238	2025-07-05 04:42:07.238				
75da0f01-6ab7-4749-b72d-51dc5b924ec6	Chicken Street			2025-07-05 04:42:12.416	2025-07-05 04:42:12.416				
738620b1-b152-46c5-aabf-2ea1ca687966	Feather Café \t	0507930741		2025-07-05 04:43:07.64	2025-07-05 04:43:07.64		CN-4353809		
0a6c0562-84e5-467e-bdba-ce4951725f8c	Harees Alfarej Restaurant \t	0506383660		2025-07-05 04:47:50.221	2025-07-05 04:47:50.221		CN-5741845		
de184760-ea6d-4995-99f5-98a1b5cca4fb	Princey Cafe			2025-07-05 04:51:55.175	2025-07-05 04:51:55.175		CN-1024717		
ee1f8d05-dbb7-4f71-bf78-7b2f611b0146	On the Block Cafe	50 743 2157		2025-07-05 04:53:35.7	2025-07-05 04:53:35.7		CN-5825141		
86b6a925-2ecc-4a49-8be5-b67941a6fc20	Ahmed Ali Refreshment 			2025-07-05 04:56:04.04	2025-07-05 04:56:04.04		CN-1022377		
08cd1c0c-3742-4f07-9c51-46365f1f6a8a	Trio Cafe	0542798894		2025-07-05 04:56:27.745	2025-07-05 04:56:27.745		CN-5122702		
581831d1-4ddc-4961-ba8a-c9d9264ce2af	Al Mersah Restaurant			2025-07-05 04:59:39.105	2025-07-05 04:59:39.105		CN-1019322		
1a1746a1-f2c1-4fd7-b3f1-bbd8a13f86f2	Al Mersah Restaurant			2025-07-05 05:02:56.657	2025-07-05 05:02:56.657				
21d35e1b-7816-4636-9e4d-bcef67fd3ac0	Al Mersah Restaurant			2025-07-05 05:03:59.968	2025-07-05 05:03:59.968				
2f313bc6-67c9-40ca-8f60-a085d556b574	On the Block Cafe	50 743 2157		2025-07-05 05:12:04.219	2025-07-05 05:12:04.219		CN-5825141		
8802dbdd-4f0c-4bb2-a737-1c7bde6e5bee	Al Kulaifi Refreshments 			2025-07-05 05:15:08.844	2025-07-05 05:15:08.844		CN-1037376		
6b8dd6d3-8055-434a-b6a5-9908107b1221	.			2025-07-05 05:18:41.555	2025-07-05 05:18:41.555				
82df7cef-d4d6-41cf-857c-31d569006dd5	.			2025-07-05 05:19:28.749	2025-07-05 05:19:28.749				
de647211-a3f8-4f47-9fb1-6372c3cfd319	Al Madad Refreshment 			2025-07-05 05:21:00.155	2025-07-05 05:21:00.155		CN-1030302		
7db36d86-cc20-4d9f-b9b2-e6e729f68605	Feathers Cafe 			2025-07-05 05:21:26.335	2025-07-05 05:21:26.335				
622fa154-e1aa-4c62-9c2e-2106a78c60d8	Feathers Cafe 			2025-07-05 05:21:30.803	2025-07-05 05:21:30.803				
9b65f94c-d7e2-49af-9d20-f4870f861c9f	Golden Dalla Meals			2025-07-05 05:21:54.139	2025-07-05 05:21:54.139		CN-1530789		
2ec95695-f140-4ea4-ad90-5d5346601518	Golden Dalla Meals			2025-07-05 05:22:42.296	2025-07-05 05:22:42.296		CN-1530789		
cdbe954a-a400-4417-b97b-8f1ece716ece	Al Madad Refreshment 			2025-07-05 05:24:16.106	2025-07-05 05:24:16.106				
513f0661-ccba-4625-8261-0c201fc95aa6	Feathers  Cafe 			2025-07-05 05:24:19.712	2025-07-05 05:24:19.712				
81996240-64a1-45ac-8f4a-96f51035260f	Ground Cafe 			2025-07-05 05:37:57.781	2025-07-05 05:37:57.781		CN-3848196		
ead920bc-dfa5-41ce-a1d3-6a11f5de1838	Ground Cafe 			2025-07-05 05:38:09.561	2025-07-05 05:38:09.561		CN-3848196		
aa4ae4d4-0a84-45e0-9de8-9b60f96f44ab	Ground Cafe 			2025-07-05 05:38:15.857	2025-07-05 05:38:15.857		CN-3848196		
d1650c12-d985-4348-94bd-1ae68abfcf17	Chantilly Cafe 			2025-07-05 05:39:03.694	2025-07-05 05:39:03.694		CN-3878752		
691fd386-ec0c-4ffc-827b-64c24ab19490	Chantilly Cafe 			2025-07-05 05:39:29.168	2025-07-05 05:39:29.168		CN-3878752		
3bf282fe-f6dc-492c-8765-23230a382a2a	Ground Cafe 			2025-07-05 05:39:53.485	2025-07-05 05:39:53.485		CN-3848196		
03701de3-4a5a-48ca-9bce-bdf275f98bdd	Cevapi House Restaurant 			2025-07-05 05:40:52.33	2025-07-05 05:40:52.33		CN-5699425		
200ef63c-0e2c-424a-946a-3d03c87e8abf	Cevapi House Restaurant 			2025-07-05 05:41:20.598	2025-07-05 05:41:20.598		CN-5699425		
ed385b67-56f6-4020-a0e2-74e849f74640	Cevapi House Restaurant 			2025-07-05 05:41:41.46	2025-07-05 05:41:41.46		CN-5699425		
57eb52d9-b016-4652-b7ad-ba3c73332727	Cevapi House Restaurant 			2025-07-05 05:42:01.929	2025-07-05 05:42:01.929		CN-5699425		
04f04f00-afae-4763-8b67-275c43f18618	Chantilly Cafe 			2025-07-05 05:42:21.064	2025-07-05 05:42:21.064		CN-3878752		
9542ce32-2006-4579-a0c3-c039dec39df2	Chantilly Cafe 			2025-07-05 05:42:29.088	2025-07-05 05:42:29.088		CN-3878752		
e4ebd7c9-db2a-42fe-9568-28f329d09947	Cevapi House Restaurant 			2025-07-05 05:42:39.498	2025-07-05 05:42:39.498		CN-5699425		
9c52dcdc-88e4-495d-bada-3e09bdf1d381	Diet Station Restaurant			2025-07-05 05:42:41.086	2025-07-05 05:42:41.086		CN-2184146		
b3d1d4cf-bf84-4fa5-8dc3-96f3c426fc60	Tea Breeze Cafeteria 			2025-07-05 05:26:42.646	2025-07-05 05:26:42.646		CN-2080614		
fd1c024e-825c-4a7c-9867-101265790067	Tea Breeze Cafeteria 			2025-07-05 05:27:20.291	2025-07-05 05:27:20.291		CN-2080614		
199c40eb-1763-4025-8857-e07160e45344	Ground Cafe 			2025-07-05 05:30:48.505	2025-07-05 05:30:48.505				
aa56ae3d-b675-4dcf-be3a-c70641d2fc74	Ground Cafe 			2025-07-05 05:31:02.827	2025-07-05 05:31:02.827				
cf1e6763-d8a1-4a01-9f30-e08504b64fb8	Chantilly Cafe 			2025-07-05 05:32:31.615	2025-07-05 05:32:31.615		CN-3878752		
eb710f04-e4ed-4bea-9092-652b1300743b	Chantilly Cafe 			2025-07-05 05:32:49.412	2025-07-05 05:32:49.412		CN-3878752		
8ee4921a-e532-459e-a1fc-42cc2a3ea0df	Cevapi House Restaurant 			2025-07-05 05:42:48.509	2025-07-05 05:42:48.509		CN-5699425		
45cc86a1-6bc1-4839-a7c6-d4d8dfdf379d	Cevapi House Restaurant 			2025-07-05 05:42:56.539	2025-07-05 05:42:56.539		CN-5699425		
0bfc4413-0e51-4860-9432-cac1bc6c20db	Typing coffee shop\t	50 541 5399		2025-07-05 05:44:07.096	2025-07-05 05:44:07.096		CN-3815830		
0b224caf-b92e-4c09-bcdb-45f19c490e04	Feather Cafe	507930741		2025-07-05 05:45:31.328	2025-07-05 05:45:31.328		CN-4353809		
c9a4bd90-6787-4623-8dc6-2da094964c89	Feather Café \t	0507930741		2025-07-05 05:49:17.845	2025-07-05 05:49:17.845		CN-4353809		
de60d1d8-12b2-47f7-b55e-c83a4ed1ba0d	Feather Café \t	0507930741		2025-07-05 05:53:22.065	2025-07-05 05:53:22.065		CN-4353809		
6418e9d1-028d-4727-95bc-c1bf54463a37	Trio Cafe	0542798894		2025-07-05 05:56:57.523	2025-07-05 05:56:57.523		CN-5122702		
167789e7-59dd-4908-a9d4-170295123e73	Tea Breeze Cafeteria 			2025-07-05 05:57:35.726	2025-07-05 05:57:35.726		CN-2080614		
93f00836-f84f-4f09-bf24-c1f2b6d91147	Trio Cafe	0542798894		2025-07-05 05:57:58.518	2025-07-05 05:57:58.518		CN-5122702		
10dacd06-2921-455e-8f40-be008bbd0015	Piece of Café\t	0569238807		2025-07-05 06:01:23.893	2025-07-05 06:01:23.893		CN-4601105		
4eeef485-fcfc-4065-8fdc-f09c08864809	Piece of Café\t	0569238807		2025-07-05 06:02:31.841	2025-07-05 06:02:31.841		CN-4601105		
e892208b-801f-45b8-8134-a7b45884559c	Piece of Café\t	0569238807		2025-07-05 06:03:35.229	2025-07-05 06:03:35.229		CN-4601105		
a67c539d-8293-426c-aa94-7cc82d12ccca	Harees Alfarej Restaurant \t	0506383660		2025-07-05 06:31:00.225	2025-07-05 06:31:00.225		CN-5741845		
44cabd7e-3e98-4e6a-804a-66727ae4d94e	rebel foods 			2025-07-05 06:34:01.552	2025-07-05 06:34:01.552				
42f84ed9-bab8-4014-ae43-863538b5368c	rebel foods 			2025-07-05 06:34:08.012	2025-07-05 06:34:08.012				
cec82f03-3c3f-42eb-97f6-1ecac5909164	rebel foods 			2025-07-05 06:35:13.436	2025-07-05 06:35:13.436				
8816df08-b391-4282-ad78-74baeee9aba4	Self-IML			2025-07-05 06:39:33.042	2025-07-05 06:39:33.042				
ab06378f-5fd3-4ada-9666-67c470194d5b	Feathers  Cafe 			2025-07-05 06:41:02.377	2025-07-05 06:41:02.377				
ddfa6625-8e60-4ab1-8686-5870092f44f5	Harees Alfarej Restaurant \t	0506383660		2025-07-05 06:43:06.143	2025-07-05 06:43:06.143		CN-5741845		
6ca2b42f-48b8-4f95-90ab-078177c891b4	Harees Alfarej Restaurant \t	0506383660		2025-07-05 06:43:56.081	2025-07-05 06:43:56.081		CN-5741845		
0f168c8c-f2f3-426f-b793-9f2a95a29768	Adnoc al Bahia 			2025-07-05 06:52:03.939	2025-07-05 06:52:03.939				
120f674f-7c25-4944-8ad9-cb68e9147129	Adnoc al Bahia 			2025-07-05 06:52:40.915	2025-07-05 06:52:40.915				
992373a3-03d2-4472-bb99-ee4a8348c872	Adnoc Khalifa City South			2025-07-05 06:53:25.451	2025-07-05 06:53:25.451				
aa54db9c-fe19-44a5-a756-9920f2eb198b	Yas Mall			2025-07-05 06:54:06.007	2025-07-05 06:54:06.007				
1ead9faa-33d2-49b7-926b-d07a9651102b	Al seef village mall			2025-07-05 06:54:39.809	2025-07-05 06:54:39.809				
f43f9e88-a1c0-4c2b-81ca-5dcc3c83f16b	Adnoc Embassies Area			2025-07-05 06:55:06.963	2025-07-05 06:55:06.963				
200d65b2-7de6-4672-a7a6-f36709e836dd	Adnoc Police College			2025-07-05 06:55:40.865	2025-07-05 06:55:40.865				
3fc50120-8acc-44fb-b88d-e6f2c0930c95	Central Mall 			2025-07-05 06:56:07.98	2025-07-05 06:56:07.98				
73d400e5-5e01-4abe-93fe-c5ce7d60baf3	Adnoc Samha			2025-07-05 07:04:19.24	2025-07-05 07:04:19.24				
6ab8b9e9-dfe6-4d72-bc8e-73405d45d183	Al Kulaifi Refreshments 			2025-07-05 07:37:40.177	2025-07-05 07:37:40.177		CN-1037376		
7b638804-ab74-4d76-9508-9e592ea580ef	Family Refreshments			2025-07-05 08:11:14.151	2025-07-05 08:11:14.151				
14c1f766-7c99-4832-ab62-6b8088fdf8ba	Mulhem Restaurant	0555877611		2025-07-05 08:56:10.529	2025-07-05 08:56:10.529				
3fcaa028-1a1a-4211-b4fa-3bba69bfb29b	rebel foods 			2025-07-05 08:56:15.57	2025-07-05 08:56:15.57				
d72478f1-9db5-4d8a-bb6d-d211ff5f7e7e	rebel foods 			2025-07-05 08:56:34.742	2025-07-05 08:56:34.742				
6a4b81a6-1efa-4dc8-8dd9-f6cd4e396f7f	rebel foods 			2025-07-05 08:56:39.54	2025-07-05 08:56:39.54				
5d61b45e-1165-445b-b77a-d29a14a2030e	Ayla Hotels & Resort			2025-07-05 09:39:21.789	2025-07-05 09:39:21.789				
049f164e-4b89-4c0d-85f6-0eb550d523b1	Tierra Cafe 	551553795		2025-07-05 09:40:27.372	2025-07-05 09:40:27.372		CN-4547944		
815d6061-9270-4f98-a4db-0b65009f460a	Tierra Cafe	0551553795		2025-07-05 09:41:24.959	2025-07-05 09:41:24.959		CN-4547944		
76daa9c8-453b-4555-9ae8-9f7db8e7400d	Tierra Cafe	506120118		2025-07-05 09:42:31.204	2025-07-05 09:42:31.204		CN-4547944		
a0cca297-6114-4c54-aa11-74928baa25e8	Lamars rest and café	971 56 229 2557-farsana		2025-07-05 09:43:13.084	2025-07-05 09:43:13.084				
2f4ebe2c-6baa-4acc-8a1f-2e942d9d20d5	Rebel Food  Restaaurant			2025-07-05 09:45:09.706	2025-07-05 09:45:09.706		CN-4391703		
99dd1b0a-0e35-43d9-9b2e-38f1a018e885	Rebel Food  Restaurant			2025-07-05 09:45:22.911	2025-07-05 09:45:22.911		CN-4391703		
3bd8c0bf-3e33-44cf-a5bd-706b4b27fcfe	Rebel Food  Restaurant			2025-07-05 09:45:32.783	2025-07-05 09:45:32.783				
5f9b643f-bac8-4ae9-a848-a0cc398ddfc1	Rebel Food  Restaurant			2025-07-05 09:45:37.499	2025-07-05 09:45:37.499		CN-4391703		
122edd0b-d9f9-4f6c-9ba5-b5fac2d8214d	Rebel Food  Restaurant			2025-07-05 09:45:42.083	2025-07-05 09:45:42.083		CN-4391703		
151f180a-1be9-4087-9da5-9289942ed44f	Mulhem Café and Specialty Coffee and Tea\t	0555877611		2025-07-05 09:48:16.144	2025-07-05 09:48:16.144		CN-5192317		
28fe9df0-54bb-429d-95c3-b6485001edfb	Mulhem Café and Specialty Coffee and Tea\t	0555877611		2025-07-05 09:48:38.83	2025-07-05 09:48:38.83		CN-5192317		
9e5e34cd-004c-4784-9419-2cff9a66abd4	Crystal Diamond Restaurant\t	50 812 0864		2025-07-05 09:49:13.768	2025-07-05 09:49:13.768		CN-4864376		
f035c546-91fb-4462-9702-da2693966c33	Ahmed Ali Refreshment 			2025-07-05 09:49:32.8	2025-07-05 09:49:32.8		CN-1022377		
bcf24ecc-c283-44ed-a57e-3a84bb84c1cb	Delice Boutique	56 331 1242		2025-07-05 09:50:19.583	2025-07-05 09:50:19.583		CN-3837115		
1a04cda7-c39e-42a7-82d3-8261e9b27a34	Harees restaurant	0566178772		2025-07-05 10:35:18.518	2025-07-05 10:35:18.518				
ceb2487e-ee7e-4232-bb3f-3da645b13891	Harees  Al Majlis Traditional Food			2025-07-05 10:35:22.718	2025-07-05 10:35:22.718				
35e1eef4-3410-4e08-bb22-3faee8cd671e	On the Block Cafe	0507432157		2025-07-05 10:56:11.708	2025-07-05 10:56:11.708				
4a47204c-423f-4255-a7ca-603f0f1f6c37	Al Mallah Restaurant & Grills	562734798    		2025-07-05 11:01:18.064	2025-07-05 11:01:18.064		CN-1106921-1		
b4b0d5a8-8702-4bf9-9e58-217d16eb53c8	Harees restaurant	0566178772		2025-07-05 11:01:46.39	2025-07-05 11:01:46.39				
1b7aa4ad-296d-48dd-a0fd-4ff2c8f7836c	Harees Alfareej Restaurant \t	0566178772		2025-07-05 11:02:24.048	2025-07-05 11:02:24.048		CN-5741845		
704e5e02-47b3-4c13-b514-292ce06681e9	McDonald's			2025-07-05 11:48:32.036	2025-07-05 11:48:32.036				
\.


--
-- Data for Name: Course; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Course" (id, title, duration, "isCertified", "isPublic", "categoryId", "createdAt", "updatedAt", shortname) FROM stdin;
6b92a3b0-f5b2-4ec3-a9ae-9a1a05a58989	Essential Food Safety Training 4	6	t	t	ac073444-9c6e-4f47-af9b-7c86a45a8fee	2025-06-10 07:31:53.755	2025-06-11 11:21:10.245	EFST-Animal Pro
e0f45b2f-55e7-4a6f-a65f-d3d9c9409372	Integrated Pest Management	6	t	f	1bb53e2d-e0c2-470a-a135-c96794f21b73	2025-06-10 07:52:52.617	2025-06-10 07:53:03.432	IPM
6d1fa60c-9ca6-461d-a552-07d0e7378f50	Basic Food Safety Training 1	6	t	t	435815a6-18cb-4b85-bab7-9609e1b3076e	2025-06-10 05:41:47.196	2025-06-11 11:21:28.328	BFST-DXB
d7dc0686-718a-491f-92c4-6bfb7745b8bc	Basic Food Safety Training 2	6	t	t	bdf4eea5-e188-475b-993d-c3f8fd20bba9	2025-05-16 09:53:26.585	2025-06-11 11:21:38.202	BFST-Fuj
29404c10-56eb-4644-9309-6fdeae3e6ad2	Essential Food Safety Training 2	4	t	t	229e1ed4-7e1e-41e2-baef-d80509d0dcac	2025-05-13 16:35:22.6	2025-06-12 08:33:45.025	EFST-Retail
8057479a-6cba-4996-a7f7-52b54f2949be	Pest Control Exam 1	1	t	t	6b44ea7e-da9e-4884-9850-8b04ca24555b	2025-06-16 07:56:12.812	2025-06-16 08:10:46.976	PC Exam Tech
1e88e10b-95f1-4b8e-9cfe-8b8a381a336d	Pest Control Training 1	6	t	t	6b44ea7e-da9e-4884-9850-8b04ca24555b	2025-06-16 07:54:50.821	2025-06-16 08:11:16.366	PC Training Tech
4b7bbda3-36c9-4dab-bd83-89cc973eef60	Pest Control Exam 2	1	t	t	d9e6c630-47c0-4048-9089-a7ad18a3f260	2025-06-16 07:55:19.368	2025-06-16 08:11:47.056	PC Exam Spvr
ae67eb73-fb4f-49e5-9ba8-6a9d8102ea47	Pest Control Exam 3	1	t	t	5b22154d-fb85-4115-a8c9-5aac0c86ec4e	2025-06-16 08:12:24.126	2025-06-16 08:12:24.126	PC Exam Mgr
3d1b1703-2450-4ff1-9cee-2ad320d63959	Testing Course in Biology	3.5	t	f	1b5c71d8-fab1-467f-9a40-b2dbe3e814d1	2025-05-22 17:23:23.901	2025-05-22 17:23:35.683	TCB
0e0fa1fb-a033-4162-85d7-fe0835f78830	Pest Control Training 2	7	t	t	5b22154d-fb85-4115-a8c9-5aac0c86ec4e	2025-06-16 08:13:30.702	2025-06-16 08:13:30.702	PC Training Mgr & Spvr
4bad3ec0-f571-4ffe-9504-737ec0db74f0	Person In-Charge 	8	t	t	1bb53e2d-e0c2-470a-a135-c96794f21b73	2025-05-16 09:14:27.132	2025-06-11 10:45:08.225	PIC Adv
cf9c2fba-baf9-441e-a72a-dc7c1939683d	Person In-Charge  	10	t	t	3d41db70-c193-4a6d-9a7e-8ebe4115919f	2025-05-16 09:14:52.807	2025-06-11 10:45:16.924	PIC Cert
2ea7bb56-6dc5-4e0c-bb23-16169ff07760	GHP Staff Training	6	t	t	25cdc5ef-87bc-4c0e-a17f-0b5a3a3dba21	2025-05-16 07:50:28.526	2025-06-11 10:45:40.665	GHP Stf
3be29657-6775-40e1-b04b-96d7d70205d4	Basic First Aid Training	5	t	t	25cdc5ef-87bc-4c0e-a17f-0b5a3a3dba21	2025-06-16 12:21:25.74	2025-06-16 12:21:25.74	BFAT
1aab3af3-6afc-463d-8ed2-eaeff7dd4510	Level 3 International Award in HACCP for Catering	7	t	t	1bb53e2d-e0c2-470a-a135-c96794f21b73	2025-06-21 07:51:00.581	2025-06-21 07:51:00.581	HACCP L3
71c6f1e5-0fb5-4140-a0c4-3968493391b8	GHP Manager Training	6	t	t	5b22154d-fb85-4115-a8c9-5aac0c86ec4e	2025-05-16 07:50:13.847	2025-06-11 10:46:59.453	GHP Mgr
a627bd22-2dbe-47d9-aaf1-309ec1ea9eba	Basic Food Hygiene Training	4.50	t	t	33b0f3ad-3b46-4947-bea3-19ad03d48804	2025-05-16 03:58:06.128	2025-06-11 10:49:52.86	BFHT-RAK-LR
16b1c73c-125a-450e-84c5-c46eb35e8329	Basic Food Hygiene Training	6	t	t	1b5c71d8-fab1-467f-9a40-b2dbe3e814d1	2025-05-16 04:02:34.129	2025-06-11 10:50:09.665	BFHT-RAK-HR
2c418f2d-c100-4f42-a4c1-e69af0c037ad	Food Safety Level 4	18	t	t	1bb53e2d-e0c2-470a-a135-c96794f21b73	2025-06-21 08:14:21.926	2025-06-21 08:31:59.645	FS L4
471a65f6-e385-499a-9846-8d0157da3274	Water Tank Cleaning and Disinfecting 	5	t	t	6b44ea7e-da9e-4884-9850-8b04ca24555b	2025-06-23 09:53:43.295	2025-06-23 09:53:43.295	WTCD-Tech-DXB
0542daa1-3922-4e3c-b592-2837e583f1ed	Essential Food Safety Training 1	6	t	t	5bb5a834-497f-4102-9840-c758a30801af	2025-05-16 03:55:49.056	2025-06-11 11:20:31.413	EFST-Catering
db9d765a-79b1-404c-b83d-9398dcd097fb	Essential Food Safety Training 3	6	t	t	5f0f339e-985b-4b0e-9d0d-e89f20036d6c	2025-05-16 03:56:22.674	2025-06-11 11:20:59.139	EFST-MFG
3d0a9897-53ae-429e-bbfc-4811694142b0	Water Tank Cleaning & Disinfecting	4	t	t	5b22154d-fb85-4115-a8c9-5aac0c86ec4e	2025-06-23 09:54:24.982	2025-06-23 09:54:24.982	WTCD-Mgr-Spvr-DXB
a00b0601-15c9-47c6-9328-d2c743df2cd4	Basic Fire Safety Training	4	t	t	1bb53e2d-e0c2-470a-a135-c96794f21b73	2025-06-25 05:48:41.003	2025-06-25 05:48:41.003	BFS
be0503b1-ff61-4eca-b4f9-be73b10e30cd	ISO 9001 2015 QMS Lead Auditor	5	t	t	1bb53e2d-e0c2-470a-a135-c96794f21b73	2025-06-28 12:08:21.219	2025-06-30 12:31:30.78	ISO 9001
\.


--
-- Data for Name: DailyNote; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."DailyNote" (id, date, note, "createdAt", "updatedAt") FROM stdin;
e24b616d-8f0b-46c7-9356-fcbfdc0954f2	2025-06-16	test	2025-06-17 16:55:17.234	2025-06-17 16:55:17.234
3dc327ed-f44e-406a-b0a6-ad0f5cdf36cf	2025-06-17	fasdf	2025-06-17 16:56:02.332	2025-06-17 16:56:02.332
361ee2fc-fc5f-446c-9a20-31b13f4a5631	2025-06-10	10th july daily note	2025-06-17 17:34:28.2	2025-06-17 17:34:28.2
7f19451d-a8bf-43ca-a21d-434efc2dfdd1	2025-06-11	11th July	2025-06-17 17:55:23.212	2025-06-17 17:55:23.212
4733ad22-f283-485d-bf47-a8f971f3154d	2025-06-18	Dr. Ghada meeting	2025-06-18 04:22:40.262	2025-06-18 04:22:40.262
15ea3b8c-4946-440a-b0a2-8b288f5c432f	2025-06-23	Call Shugufta-DM to check the online session	2025-06-21 10:50:03.139	2025-06-21 10:50:03.139
fb3ec61b-fbb3-4abd-ba92-fa1d8bab89c6	2025-06-27	Al Hijri Holiday	2025-06-24 04:31:39.55	2025-06-24 04:31:39.55
6d8dba52-288b-4ae9-8a37-93af43e02b3f	2025-06-25	1. Meeting-Almarai SHJ-Trainers Introduction 2. Meeting-PC Tech training material-Dr. Ghada	2025-06-24 10:59:13.518	2025-06-24 12:22:37.778
3dff82bf-1e33-4771-a511-ec03d0d16368	2025-07-12	Don't book anything - c/o ma'am Ghada	2025-06-26 05:17:23.461	2025-06-26 05:17:23.461
bf0af727-2627-4099-b97a-5733a388068e	2025-07-03	1.  Staff Meeting at 4:15 pm	2025-07-02 10:55:23.385	2025-07-03 06:17:05.372
e8b0aeac-7a48-4aaa-bdfc-4c10d1d0b85a	2025-07-31	HACCP Level 3 Training - Highfield Cert	2025-07-04 04:18:05.801	2025-07-04 04:18:05.801
d18b77f7-5892-448f-b40d-21c50ff451ca	2025-07-23	EFST Training-Anjali-Radisson-15	2025-07-04 10:36:02.214	2025-07-04 10:38:29.295
befc2860-7d14-4c44-a900-210b4759bd84	2025-07-21	EFST Training-Anjali-LeMeridien-15	2025-07-04 10:35:16.857	2025-07-05 05:12:26.864
f8ea9429-a724-4001-916d-027e73f09925	2025-07-22	EFST Training-Anjali-Sheraton-15	2025-07-04 10:35:49.484	2025-07-05 05:12:44.131
d59b5117-536f-44c5-a8bb-e01680c69b6d	2025-07-05	1. Bijay-OFF\n2. Dr. Ghada-Online meeting-Farsana-12:00pm\n3. Dr Ghada-Online translation-PC Supervisor-zoom-1:00pm\n4. RMK Admin/Dr. Ghada - Vishnu - 3:00pm	2025-07-03 05:05:00.416	2025-07-05 07:57:49.024
\.


--
-- Data for Name: Delegate; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Delegate" (id, "sessionId", name, "emiratesId", phone, email, "companyName", "isCorporate", "photoUrl", "createdAt", "updatedAt", "seatId", status, "clientId", paid, quotation) FROM stdin;
41185a93-1804-482b-9229-36e3f761542b	6bf1984a-a489-486c-8f0a-07fa39412c2f	Biplab Paul Rodricks 	784198318242900	562689306	biplabrodricks32@gmail.com	Fassco Catering Services LLC/Danat 	f		2025-06-19 04:42:46.949	2025-06-19 04:42:46.949	S1	NOT_CONFIRMED	\N	f	
15395142-956e-40f7-a9d8-98eb6fc10f33	4bc85338-67fc-4111-9dd0-732198a19e10	Mohamed Shafeeq  Kummalil Moideen 	784198908419751			Golden Dalla Meals 	f		2025-07-05 10:20:01.567	2025-07-05 10:20:01.567	S5	NOT_CONFIRMED	9b65f94c-d7e2-49af-9d20-f4870f861c9f	f	
561e923b-0e73-4349-b5ee-047637e6968c	dedcda77-5403-4631-be6c-111b66c03983	Lowela Maminta				Kitopi	f		2025-06-10 07:26:38.694	2025-06-10 07:26:38.694	S5	NOT_CONFIRMED	3a9a8f6e-fa8c-47be-a1d3-53e01e222a0a	f	
2e4a9c74-f8a4-472c-8895-2b035d011ff5	dedcda77-5403-4631-be6c-111b66c03983	Lowela				Kitopi	f		2025-06-10 07:26:38.694	2025-06-10 07:26:38.694	S1	NOT_CONFIRMED	3a9a8f6e-fa8c-47be-a1d3-53e01e222a0a	f	
ffe3b807-d81c-49eb-b55a-812373c6f76d	4bc85338-67fc-4111-9dd0-732198a19e10	Firos Palli Kandi 	784199332082181	0509046007	firospk234@gmail.com	Break Time Cafeteria 	f		2025-07-05 10:20:01.567	2025-07-05 10:20:01.567	S1	CONFIRMED	66daed1f-3bb4-4e98-a4e3-3adb9735825b	f	
a4c37b1a-9452-420e-8a0c-16c599f05018	4bc85338-67fc-4111-9dd0-732198a19e10	Nowshad Kottikulam 	784197617398330	0569867709	zammizammi4@gmail.com	Break Time Cafeteria 	t		2025-07-05 10:20:01.567	2025-07-05 10:20:01.567	S2	CONFIRMED	0d98d9ab-bc87-4eb4-9875-5a076e370b95	f	
333e45d7-170b-4501-a86b-6651a93cd439	4bc85338-67fc-4111-9dd0-732198a19e10	Sunil Kumar 	784198467701615	0568304656	sunilparporkalam@gmail.com	Break Time Cafeteria 	f		2025-07-05 10:20:01.567	2025-07-05 10:20:01.567	S3	CONFIRMED	d1c1ae28-09ee-4c0b-8231-f0e5c4cd66fc	f	
5aac9376-43dc-4832-b3c7-d44e180fc3b6	4bc85338-67fc-4111-9dd0-732198a19e10	Mohamed Ashikh Mattathu	784199459837169	0566881494	sameervpr@gmail.com	Al Madad Refreshment 	f		2025-07-05 10:20:01.567	2025-07-05 10:20:01.567	S4	CONFIRMED	de647211-a3f8-4f47-9fb1-6372c3cfd319	f	
285e69e9-ae3e-4e0d-b2da-5856389d119a	bc2cdee9-202b-4ac4-a812-10222662d5e1	abhi	784200042812535	0581075922	abhi98@gmail.com	hypermarket	f		2025-06-10 19:42:24.85	2025-06-10 19:42:24.85	S1	CONFIRMED	4ad20377-f656-4d0d-9f2d-a9ce0beeb416	f	120
7a4cc9f5-4bc3-42cb-af07-a80a487d6024	bc2cdee9-202b-4ac4-a812-10222662d5e1						f		2025-06-10 19:42:24.85	2025-06-10 19:42:24.85	S2	NOT_CONFIRMED	4bd2ff98-b0ef-4ca2-92a5-64a0db6db121	f	
cfbcf43a-ff86-4a4a-8f3b-6674c3e48d30	4bc85338-67fc-4111-9dd0-732198a19e10	Junaid Melethil Kuttu 	784199586907547	0567589882	junaidmelethil1995@gmail.com	Golden Dalla Meals 	f		2025-07-05 10:20:01.567	2025-07-05 10:20:01.567	S6	CONFIRMED	2ec95695-f140-4ea4-ad90-5d5346601518	f	
9316581b-bc5b-4a95-ab2a-916f38cd0a98	4bc85338-67fc-4111-9dd0-732198a19e10	Raheem Pariyaran Moideen 	784199939924926	0561171248	kpraheem421@gmail.com	Al Madad Refreshment 	f		2025-07-05 10:20:01.567	2025-07-05 10:20:01.567	S7	CONFIRMED	cdbe954a-a400-4417-b97b-8f1ece716ece	f	
02518370-95e8-441e-a906-f34966e3c9ed	4bc85338-67fc-4111-9dd0-732198a19e10					Fresh Samawar Restaurant and Cafe 	f		2025-07-05 10:20:01.567	2025-07-05 10:20:01.567	S8	NOT_CONFIRMED	1997e955-3774-441d-9761-faff1d9bb3dc	f	
009643dd-adae-4063-949a-ff67c155c10b	4bc85338-67fc-4111-9dd0-732198a19e10	Muhammed Rafi Moottaparamban	784198867269239	0543595265	kunhippajasirichu@gmail.com	Chicken Street Cafeteria 	f		2025-07-05 10:20:01.567	2025-07-05 10:20:01.567	S9	CONFIRMED	171b7a78-ed7a-43b8-88dc-15cf208cb608	f	
d56debb4-3be2-4a9d-b960-0d1c450bfddf	4bc85338-67fc-4111-9dd0-732198a19e10	Ummer Parangal Saidlavi 	784198896365115	0529047323	ummarvnr81@gmail.com	Chicken Street 	f		2025-07-05 10:20:01.567	2025-07-05 10:20:01.567	S10	CONFIRMED	75da0f01-6ab7-4749-b72d-51dc5b924ec6	f	
eaaa593b-9d43-41fc-aea8-cdaf1ac2bb97	4bc85338-67fc-4111-9dd0-732198a19e10	Mohammed Shereef Gudrakandam	784197873980250	0558779205	shereefg9@gmail.com	Al Mersah Restaurant	f		2025-07-05 10:20:01.567	2025-07-05 10:20:01.567	S11	CONFIRMED	581831d1-4ddc-4961-ba8a-c9d9264ce2af	f	
b507fd94-0b6c-4214-b33c-799e55909357	4bc85338-67fc-4111-9dd0-732198a19e10	Sherin Shibu 	784200060114103	0508311638	sherinappu74@gmail.com	Al Mersah Restaurant 	f		2025-07-05 10:20:01.567	2025-07-05 10:20:01.567	S12	CONFIRMED	1a1746a1-f2c1-4fd7-b3f1-bbd8a13f86f2	f	
9e8eaa41-e842-404d-b5e5-1f8693c95433	b31603a5-c3b1-4634-ab59-7991d472803f	Khrisna Ayer	784199973040068	522390189	blancokhrisnaayer@gmail.com	La Brioche	f		2025-06-25 06:00:29.472	2025-06-25 06:00:29.472	S4	CONFIRMED	bee8b203-f7a7-45d0-96a1-e13a4b450bd8	f	
b401132f-78e8-400e-ae1e-bc741dbc2e0b	b31603a5-c3b1-4634-ab59-7991d472803f	Rita Baokye	784199455823825	554546528	ritaboakye8@gmail.com	Besbyte African Restaurant\t	f		2025-06-25 06:00:29.472	2025-06-25 06:00:29.472	S5	CONFIRMED	120c2390-630e-4e02-9a1b-cf580ba7ad0f	f	
3ccf6b81-a759-4c5e-8b09-20a90e625c05	b31603a5-c3b1-4634-ab59-7991d472803f	Blessing Acha Titang	784199912447515	528225856	blessingtitang84@gmail.com	Just Fresh Juice Cafeteria\t	f		2025-06-25 06:00:29.472	2025-06-25 06:00:29.472	S6	CONFIRMED	0b8e31aa-4349-4f36-8659-aa51c65d0e73	f	
9c768cc1-6273-402a-87df-bbca1c88591a	b31603a5-c3b1-4634-ab59-7991d472803f	Bishal Rai	784199955992724	545603471	bishal.rai1998@icloud.com	Just Fresh Juice Cafeteria\t	f		2025-06-25 06:00:29.472	2025-06-25 06:00:29.472	S7	CONFIRMED	3a479f4b-9e9b-44b3-b2dd-17af7b7e6a2f	f	
c846fe2d-6c24-40a0-8eda-aadc697906ae	4bc85338-67fc-4111-9dd0-732198a19e10	Moosa Abdul Manaf	784199615666932	0508494203	abdulmoosa20@gmail.com	Al Mersah Restaurant 	f		2025-07-05 10:20:01.567	2025-07-05 10:20:01.567	S13	CONFIRMED	21d35e1b-7816-4636-9e4d-bcef67fd3ac0	f	
b15e71ce-ef56-46d8-a436-b763a2559a9a	8cfe99e6-f724-4928-9fa8-4ab14817c1e3	Ahmad Burhan Mohammad Alnusairat	784199631490358			Alphamed 	f		2025-07-02 09:59:29.531	2025-07-02 09:59:29.531	S1	CONFIRMED	e8e51c2f-4e4c-4476-ade2-faf5d0eaa8a2	f	
9b354b36-ee03-4baa-b48e-f1dd4dfdb5d3	8cfe99e6-f724-4928-9fa8-4ab14817c1e3	Kamran Ali Shahbaz Dino	784199414315806			Alphamed 	f		2025-07-02 09:59:29.531	2025-07-02 09:59:29.531	S2	CONFIRMED	8724ac68-3290-4c25-8278-b0363f511f3d	f	
7cb16e5d-792e-42c2-91a5-e6e4c3ea2a02	7fc927e7-65a8-4aa6-a12b-158af55bce5f					Grand mart	f		2025-07-04 10:07:21.154	2025-07-04 10:07:21.154	S1	CONFIRMED	e61283fd-8437-4066-aae1-93f46598708e	f	
3daaecf9-1b8b-4a59-8a13-bae72c9567d5	7fc927e7-65a8-4aa6-a12b-158af55bce5f	Grand mart				Grand mart	f		2025-07-04 10:07:21.154	2025-07-04 10:07:21.154	S2	CONFIRMED	27bf91bb-eb45-4ba4-8502-8a1146c2a22e	f	
042a21d8-4497-4280-bebe-a2828c636548	1ed26bb5-f808-41f8-bec3-6817e154604e	Abdelrazak Farrag 	784198618574028	568823711	abdozazy9999@gmail.com	Akl Zaman Restaurant & Cafeteria 	f		2025-06-19 09:49:33.664	2025-06-19 09:49:33.664	S1	CONFIRMED	e0984f99-6261-4c7a-99f2-2a8aa92e6003	f	
5f78c966-3b68-461b-afbf-ab3fb1ca2174	94c4649d-436b-40bc-b6b3-f41059f83d20	Abdul Gafoor Konganda 	784198992196588	0566581838	kcgafoor4@gmail.com	Air Fresh  Baqala 	f		2025-06-19 12:44:46.965	2025-06-19 12:44:46.965	S1	CONFIRMED	e23d8618-437c-4a6a-b57f-85c6d642abec	f	
9686cd87-5c6d-4ea1-b63f-341a71f6f250	94c4649d-436b-40bc-b6b3-f41059f83d20	Muhammed Ashraf 	784198960418253	564402057	ashrafam1176@gmail.com	Bin Salem Grocery	f		2025-06-19 12:44:46.965	2025-06-19 12:44:46.965	S2	CONFIRMED	3706599f-368b-4e7b-94f1-3ab2863394ee	f	
6e7d63ec-a67c-4f9f-b28c-38f422a138c8	94c4649d-436b-40bc-b6b3-f41059f83d20	Rachel			eltokyadbo22@gmail.com	RMK	f		2025-06-19 12:44:46.965	2025-06-19 12:44:46.965	S3	CONFIRMED	31352de1-ede2-4899-b78e-f5b1c0686752	f	
005a36bf-9ab8-4bd3-9354-0562fb0d6fd7	d8c65465-c065-4390-bb6d-3d0b848196d4	Ali Murad	784199916402078	502358957		Al Hor Camping and Hunding Tools\t	f		2025-06-18 09:25:29.95	2025-06-18 09:25:29.95	S5	CONFIRMED	2e3fe1ee-ab9d-438a-8e8b-c5966148b31a	f	
e0137fdb-43a5-4e42-aac3-aa5bc640e6fa	d8c65465-c065-4390-bb6d-3d0b848196d4	Asif Ali Shakir Ali	784199870746320	568632807		Al Hor Camping and Hunding Tools\t	f		2025-06-18 09:25:29.95	2025-06-18 09:25:29.95	S6	CONFIRMED	3e812f04-3617-4dba-81de-16f259517260	f	
2732041f-f851-44d1-a6fb-adca2426793a	d8c65465-c065-4390-bb6d-3d0b848196d4	Mohd Abuzar	784199876859051	509237190		Zahrat Abu Samra Grocery\t	f		2025-06-18 09:25:29.95	2025-06-18 09:25:29.95	S7	CONFIRMED	7798d514-509c-45f0-84b3-3b13f1dfe4d0	f	
62618f60-2631-4bc1-bab7-98e9ff75ddc5	d8c65465-c065-4390-bb6d-3d0b848196d4	Abdulla Shohidullah 	784199859725683	506830585		Regullar Baqala\t	f		2025-06-18 09:25:29.95	2025-06-18 09:25:29.95	S8	CONFIRMED	520c2e5c-1658-4ac8-8b16-8d8b71dd1d0f	f	
2b24599d-6f89-420c-9625-6bdada99984b	d8c65465-c065-4390-bb6d-3d0b848196d4	Mohammed Salam 	784199365410606	562273889		Noor Al Anka Grocery \t	f		2025-06-18 09:25:29.95	2025-06-18 09:25:29.95	S1	CONFIRMED	5720cb33-bd94-4ee3-9a86-7d327bb0d443	f	
baf95565-c155-4229-86c7-937b4b201a42	d8c65465-c065-4390-bb6d-3d0b848196d4	Jamal Uddin Manir	784197861520373	567188938		Noor Al Anka Grocery \t	f		2025-06-18 09:25:29.95	2025-06-18 09:25:29.95	S2	CONFIRMED	154db7a4-e280-4be7-aff4-2f6fc7ea2d06	f	
37f1516e-6f43-4bd3-92ce-8d1c98da8a26	d8c65465-c065-4390-bb6d-3d0b848196d4	Abdul Latheef	784196836565562	527715981		Al Hamwi Global General Trading \t	f		2025-06-18 09:25:29.95	2025-06-18 09:25:29.95	S3	CONFIRMED	a0cbcab5-7f54-411e-91f3-d7215aea3649	f	
9ffb30ed-fa82-4212-ac05-645df8c05b68	d8c65465-c065-4390-bb6d-3d0b848196d4	Md Ismail Hossain 	784199923549143	544365356		MSH Baqala \t	f		2025-06-18 09:25:29.95	2025-06-18 09:25:29.95	S4	CONFIRMED	102d69f2-6197-4e96-8a6e-0b49b2ec68d3	f	
aaaa438c-bf58-42c6-b27b-f88dae83086f	7fc927e7-65a8-4aa6-a12b-158af55bce5f					Grand mart	f		2025-07-04 10:07:21.154	2025-07-04 10:07:21.154	S3	CONFIRMED	53e69e14-c6dd-4b63-8ee9-ca4b4a6257b2	f	
8fea824c-2fbf-4846-829a-eedc32b2d55b	7fc927e7-65a8-4aa6-a12b-158af55bce5f					Grand mart	f		2025-07-04 10:07:21.154	2025-07-04 10:07:21.154	S4	CONFIRMED	ec5ada02-23a3-492b-a681-f957c92e4950	f	
ec37a73b-587c-43db-b723-69231d6afc9c	7fc927e7-65a8-4aa6-a12b-158af55bce5f					Wood House Restaurant	f		2025-07-04 10:07:21.154	2025-07-04 10:07:21.154	S8	NOT_CONFIRMED	154d60df-4ca8-4be4-8d20-ab9b4289ba74	f	
62e63fde-5ea8-4f89-a372-640d2fd854c6	7fc927e7-65a8-4aa6-a12b-158af55bce5f					Wood House Restaurant	f		2025-07-04 10:07:21.154	2025-07-04 10:07:21.154	S9	NOT_CONFIRMED	154d60df-4ca8-4be4-8d20-ab9b4289ba74	f	
8561f1c9-bcde-488d-a713-7011a60f6ff1	4bc85338-67fc-4111-9dd0-732198a19e10	Sameer Cherakadath 	784198258706047	0504272503	Niyazkgl@gmail.com	Al Kulaifi Refreshments 	f		2025-07-05 10:20:01.567	2025-07-05 10:20:01.567	S15	CONFIRMED	6ab8b9e9-dfe6-4d72-bc8e-73405d45d183	f	
3d6beec2-a9b6-4204-aa11-8babff5037d4	4bc85338-67fc-4111-9dd0-732198a19e10					Family Refreshments 	f		2025-07-05 10:20:01.567	2025-07-05 10:20:01.567	S14	NOT_CONFIRMED	7b638804-ab74-4d76-9508-9e592ea580ef	f	
08a96e76-ceb2-4e9a-b223-815956be081c	a6fbafb8-1171-46e5-ae8c-c08d1a641971	Sourav Biswas Aghore 	784199652522212	0563742050	bsourav058@gmail.com	Kitopi	t		2025-06-24 07:52:00.364	2025-06-24 07:52:00.364	S2	CONFIRMED	87bb89ac-304b-49c4-83cd-9289fb006587	f	
43bcd2b6-587b-4bfa-9c63-c59de8a070ef	a6fbafb8-1171-46e5-ae8c-c08d1a641971	Dinesh Shahi 	784199524110360	0564728776	dinesh.shahi@kitopi.com	Kitopi	t		2025-06-24 07:52:00.364	2025-06-24 07:52:00.364	S3	CONFIRMED	87bb89ac-304b-49c4-83cd-9289fb006587	f	
979a352b-4d47-4253-ba37-967946ece256	a6fbafb8-1171-46e5-ae8c-c08d1a641971	Rome Andre Garcellano Francia 	784200124787431	0505816207		Future Ride Scoot Shop	f		2025-06-24 07:52:00.364	2025-06-24 07:52:00.364	S8	CONFIRMED	76b5fcc1-f263-4823-b96a-8f1f6c75c39c	f	
a2cce6b4-d333-424e-bd25-bd90437577bf	a6fbafb8-1171-46e5-ae8c-c08d1a641971	Karan Darjee 	784200410565525	0507692279	karan.darjee@kitopi.com	Kitopi Restaurant 	t		2025-06-24 07:52:00.364	2025-06-24 07:52:00.364	S1	CONFIRMED	e7271e0c-a48c-4fa6-a3c7-e7853110e6ec	f	
4dc6063c-074f-4263-b448-0574bb4f2fdc	a6fbafb8-1171-46e5-ae8c-c08d1a641971	Laveesh  Nagpal Roshan 	784198697398455	567296207		Edition Hotel 	f		2025-06-24 07:52:00.364	2025-06-24 07:52:00.364	S9	CONFIRMED	187266f2-2a0f-4336-aafe-bc5ebcf80ded	f	
ebff5728-7f21-40b5-b0bb-99efa3a73ff7	a6fbafb8-1171-46e5-ae8c-c08d1a641971	Jairo Pegares Mijares	784199268014125	0509280348	jairomijares4@gmail.com	Cravia	f		2025-06-24 07:52:00.364	2025-06-24 07:52:00.364	S10	CONFIRMED	246d3ca0-36c8-4561-a4dc-230260bc23a4	f	
0ca02d46-7347-45bf-b965-816586af944a	94427a80-8b8c-4b4b-921e-82cd114b73fd	Rachel 	784452369512536	0563203966	jabirnk905@gmail.com	Foxxy Café	f		2025-06-16 10:40:07.419	2025-06-16 10:40:07.419	S1	NOT_CONFIRMED	3ee36362-4c95-4f20-bd3f-8a452f45f3f7	f	
407daafd-9a00-4fda-9c6a-df185fcf75ca	bcdf72e1-cb45-4994-bdb2-c0878fcc5ecf	Muhammed Shabeer 	784200176537791	505973100	shabeerkarakkulaven@gmail.com	Al Ehtifal Fruits & Vegetables\t	f		2025-06-16 17:52:40.921	2025-06-16 17:52:40.921	S9	NOT_CONFIRMED	624363f0-305b-4060-9df6-9d4d927f4eb3	f	
6ca1d9b2-8f13-4670-8635-6dccfb0100f0	07c11140-b7c6-4009-806b-ee7c97a3cad3	Rachel					f		2025-06-19 13:21:47.895	2025-06-19 13:21:47.895	S1	CONFIRMED	5f2d859e-28ce-4e2f-a0eb-55a72ae9835c	f	
ffdf0ab6-aaf3-4b7b-a480-6c8e47d9d93f	07c11140-b7c6-4009-806b-ee7c97a3cad3	Lowela					f		2025-06-19 13:21:47.895	2025-06-19 13:21:47.895	S2	CONFIRMED	f8c20dd3-4cc8-4122-8f2c-de44d58d632b	f	
59bc23d6-9a61-4407-b964-d2a3ad22b221	07c11140-b7c6-4009-806b-ee7c97a3cad3	Mwlinda					f		2025-06-19 13:21:47.895	2025-06-19 13:21:47.895	S3	CONFIRMED	d1763292-d79c-4f63-8780-af49962977f6	f	
547344db-eda3-41cb-bb39-3994ff2fe87c	07c11140-b7c6-4009-806b-ee7c97a3cad3	Maruyam					f		2025-06-19 13:21:47.895	2025-06-19 13:21:47.895	S4	CONFIRMED	180f1ce7-2053-4e2d-a525-7729aa39062b	f	
d69c094f-37e4-404b-a75a-67fa867fb008	07c11140-b7c6-4009-806b-ee7c97a3cad3	Ann					f		2025-06-19 13:21:47.895	2025-06-19 13:21:47.895	S5	NOT_CONFIRMED	e0984f99-6261-4c7a-99f2-2a8aa92e6003	f	
4eb11eb4-7f0e-4c4f-8dcf-d930955c5316	786f272a-16a8-4d57-9699-187f10029c92	Ahmed Mohamed Ali Qambar Hasan				Bahrain Flour Mills Co BSC	t		2025-06-17 04:48:43.192	2025-06-17 04:48:43.192	S1	CONFIRMED	\N	f	
f92ead2c-8f2f-4e39-8628-4b02d1ef3287	5f52f509-bb57-41a9-ab6d-16e86933f8c7	Salman Farish		0545422064	sfarish433@gmail.com	Edition Hotel Abu Dhabi	t		2025-06-17 07:27:55.999	2025-06-17 07:27:55.999	S1	CONFIRMED	fac37f30-e03f-4e8f-a8c3-26abbbcc3dff	f	
26e621ec-e1c2-4c5d-8ad1-9d4cdd68ea21	5f52f509-bb57-41a9-ab6d-16e86933f8c7	Rajesh Thadathil Thankappan					f		2025-06-17 07:27:55.999	2025-06-17 07:27:55.999	S2	CONFIRMED	30e3d0f2-d4e2-4a2e-a053-db23dcd666d1	f	
08f33de8-4643-4e29-9dc6-bfb045915eda	9ef74971-3796-48b1-8baa-f875a2138999	Anil Bharati 	784200379524372	588391346	anilbharati102@gmail.com	Chick Choice Plus Restaurant 	f		2025-06-18 09:30:16.077	2025-06-18 09:30:16.077	S1	CONFIRMED	2671a70e-5c71-4670-8167-ed53608874f1	f	
d61b8894-600b-49bf-a22c-0ceb282e60cc	9ef74971-3796-48b1-8baa-f875a2138999	Muhammad Shahzad 	784197951043351	503882647		Chick Choice Plus Restaurant 	f		2025-06-18 09:30:16.077	2025-06-18 09:30:16.077	S2	CONFIRMED	36bbde4c-b54f-475c-9a81-c7e51b056c40	f	
6e008ad7-9c9e-43f5-9c2b-e1a22bade47d	2c25d1dc-2043-40df-95ff-eaf843fdd6fb	Rohamin Kemarao Kasan	784199686886021	0582688212	rohaminkasan43@gmail.com	Mohammed Rasool Khoory & Sons	f		2025-07-01 10:18:09.617	2025-07-01 10:18:09.617	S1	CONFIRMED	d67d4500-46d2-4a2a-b002-976d7f1c91c3	f	
49a0a0c4-e622-4283-b557-e6e9acb01f82	bcdf72e1-cb45-4994-bdb2-c0878fcc5ecf	Safvan Thekkinkadan Muhammed	784199096515947	527673002	safvan@gmail.com	Just Silver grocery\t	f		2025-06-16 17:52:40.921	2025-06-16 17:52:40.921	S1	NOT_CONFIRMED	4092d932-d667-4192-b0be-a191e81a082f	f	
d8e1c026-afcd-4385-b7e9-66774f0aacee	bcdf72e1-cb45-4994-bdb2-c0878fcc5ecf	Shameem Imthiyaz	784200283461406	568480895	imthiyazshameem0@gmail.com	Al Taleb Grocery \t	f		2025-06-16 17:52:40.921	2025-06-16 17:52:40.921	S2	NOT_CONFIRMED	77f91b77-08fe-4451-ac63-bf82e681e7bd	f	
8c4e8b7a-8ab9-4298-94c5-d6bebafd6acb	bcdf72e1-cb45-4994-bdb2-c0878fcc5ecf	Fameesh Tharayil 	784199146994027	568429915	fameeshtharayil@gmail.com	Alafdaliya General Trading 	f		2025-06-16 17:52:40.921	2025-06-16 17:52:40.921	S3	NOT_CONFIRMED	1d2bbec7-6e86-4fc1-9bd0-4b190715d17d	f	
3ec84f9e-03a1-483d-839c-0d320231e166	bcdf72e1-cb45-4994-bdb2-c0878fcc5ecf	Abdunnasar Kolliyath Yoosuf 	784198877478291	509595870	nasarsunami0@gmail.com	Alafdaliya General Trading 	f		2025-06-16 17:52:40.921	2025-06-16 17:52:40.921	S4	NOT_CONFIRMED	61eabe89-d77c-4cfe-9ce1-6a230d341def	f	
45e7b44c-3573-4d9b-a52b-1f77612be419	bcdf72e1-cb45-4994-bdb2-c0878fcc5ecf	Kwaja Moideen 	784197526404765	509529239	kwajamoideen@gmail.com	Al Ajwa Baqala \t	f		2025-06-16 17:52:40.921	2025-06-16 17:52:40.921	S5	NOT_CONFIRMED	2ae3fe6e-dc12-4787-9c32-99ad563b4224	f	
67914dfc-6cc5-4f2e-bc51-fa91baddaf47	fd5cc5be-5841-4a61-990b-748044281992	Haitham Mohamed Abdelaziz	784198023638368	508668770	mostafahr140@gmail.com	HDMS Fruits and Vegetables	f		2025-06-17 10:00:09.829	2025-06-17 10:00:09.829	S1	NOT_CONFIRMED	90f3ba09-d388-45ec-be57-4cb5b46897ad	f	
5d750b35-d6b6-4daa-9b89-1a2cf2ea4197	fd5cc5be-5841-4a61-990b-748044281992	Mohamed Barah	784200294296403	525241588		Chaonene Market \t	f		2025-06-17 10:00:09.829	2025-06-17 10:00:09.829	S2	NOT_CONFIRMED	d02f8362-5097-4e5f-adb1-f0036a800004	f	
8904638a-b951-422e-a86f-929278d59659	fd5cc5be-5841-4a61-990b-748044281992	Mhd Adnan Mhd	784199564081844	521696640		Doltchi Flowers and Perfumes \t	f		2025-06-17 10:00:09.829	2025-06-17 10:00:09.829	S3	NOT_CONFIRMED	1a00b771-50f2-446c-a528-8be1a62b35ae	f	
0b16daa6-caf1-4e0f-ada6-7b7853cc67ac	fd5cc5be-5841-4a61-990b-748044281992	Mohamad Emad	784200259000956	563805279		Lorans Rose Flowers and Perfumes\t	f		2025-06-17 10:00:09.829	2025-06-17 10:00:09.829	S4	NOT_CONFIRMED	7fcd08f9-daef-45d8-b9c7-8349f2f9fd84	f	
f038a0d1-0306-418e-9c77-94a44a6545a5	fd5cc5be-5841-4a61-990b-748044281992	Fadel Mohammad	784198027438054	0507637653		Growth Food stuff Trading \t	f		2025-06-17 10:00:09.829	2025-06-17 10:00:09.829	S5	NOT_CONFIRMED	4254c6d0-39e1-4d87-a89a-d88257e13356	f	
541f6bbf-9fff-4490-9707-ee2cf110f7e2	fd5cc5be-5841-4a61-990b-748044281992	Amar Lakhdari	784199487050397	581381056		Al Hor Camping and Hunding Tools\t	f		2025-06-17 10:00:09.829	2025-06-17 10:00:09.829	S6	NOT_CONFIRMED	fbf4de8b-c098-4ccc-a564-35626df0fb16	f	
b47ff0b5-a66d-4ca8-991f-bbbbc14036c7	fd5cc5be-5841-4a61-990b-748044281992	Moataz Abdellatif 	784198730637695	564270343		Al Hor Camping and Hunding Tools\t	f		2025-06-17 10:00:09.829	2025-06-17 10:00:09.829	S7	NOT_CONFIRMED	0669a76b-cdfd-48ba-94ee-6bab32860c65	f	
ba35ff20-ca2a-462c-8b61-5ef77a2c5d53	fd5cc5be-5841-4a61-990b-748044281992	Shehabeldan Mohamed	784199974540108	502956366		Chaonene Market \t	f		2025-06-17 10:00:09.829	2025-06-17 10:00:09.829	S8	NOT_CONFIRMED	db268d2d-12f0-45af-b9fd-3a25eba4373d	f	
81db6a1f-1b6f-4c5b-8903-b19c7107b996	75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	Kamana Sunar	784200153612534	568472711	kamnasenchury@gmail.com		t		2025-06-26 12:01:26.497	2025-06-26 12:01:26.497	S5	CONFIRMED	10c975d4-f918-40fd-b941-bdb6d4e41a7b	f	
7a9e9400-5f3b-4579-aa19-2e0dcb7ddd08	bec3c6f9-2b6a-4809-9b40-da24eda24376	Abdullatief Kavapura	784196580203261	507607639		Al Sultan bakery and Supermarket 	f		2025-06-18 05:27:23.496	2025-06-18 05:27:23.496	S1	NOT_CONFIRMED	20cd78be-6c86-4289-afcb-7ae90bdb3a6b	f	
9aa891fe-bced-4e73-aff6-71db37750f05	bec3c6f9-2b6a-4809-9b40-da24eda24376	Rafeeq Pavutta Kunnan	784198617909209	502396893	rafeeqshifin@gmail.com	Al Sultan bakery 	f		2025-06-18 05:27:23.496	2025-06-18 05:27:23.496	S2	NOT_CONFIRMED	7618a8a7-4d1a-4aa9-85f7-a009274b7a00	f	
fc451ad6-e611-46c2-8a2b-766e41d72805	3fd2a0f5-e0ac-449a-a379-69ff747f6430	DEXTER CASTILLON					f		2025-06-16 06:12:52.517	2025-06-16 06:12:52.517	S1	CONFIRMED	bccf57b5-6d80-4d89-893a-823c5882d574	f	
70caf88d-15b1-4aa6-8509-d2cabebcadf0	3fd2a0f5-e0ac-449a-a379-69ff747f6430	SUSHMA PUTUWAR				FASSCO Danat	f		2025-06-16 06:12:52.517	2025-06-16 06:12:52.517	S2	CONFIRMED	bccf57b5-6d80-4d89-893a-823c5882d574	f	
29743caa-0e28-432c-b8dd-69df2f6d9f84	3fd2a0f5-e0ac-449a-a379-69ff747f6430	ANKAN NATH				FASSCO Danat	f		2025-06-16 06:12:52.517	2025-06-16 06:12:52.517	S3	CONFIRMED	bccf57b5-6d80-4d89-893a-823c5882d574	f	
cd2317ad-2a58-42b7-b677-e451defab6a4	3fd2a0f5-e0ac-449a-a379-69ff747f6430	PRITI RANA 				FASSCO Danat	f		2025-06-16 06:12:52.517	2025-06-16 06:12:52.517	S4	CONFIRMED	bccf57b5-6d80-4d89-893a-823c5882d574	f	
6423af47-46c9-4718-bc78-dd5fdea1e9e6	3fd2a0f5-e0ac-449a-a379-69ff747f6430	GHANSYAM CHAUDHARY 				FASSCO Danat	f		2025-06-16 06:12:52.517	2025-06-16 06:12:52.517	S5	CONFIRMED	bccf57b5-6d80-4d89-893a-823c5882d574	f	
19039464-1395-4185-bdc9-db15ac6581ce	3fd2a0f5-e0ac-449a-a379-69ff747f6430	HARKAMAN GURUNG 				FASSCO Danat	f		2025-06-16 06:12:52.517	2025-06-16 06:12:52.517	S6	CONFIRMED	bccf57b5-6d80-4d89-893a-823c5882d574	f	
95ce91fe-dafe-4a62-857b-ebebe9b8e9b2	bcdf72e1-cb45-4994-bdb2-c0878fcc5ecf	Muhammad Mishal Para	784200591431901	507998664	mishalpk.gamil.com@gmail.com	Charminar Baqala/Instamart Baqala 	f		2025-06-16 17:52:40.921	2025-06-16 17:52:40.921	S6	NOT_CONFIRMED	45444159-0667-4d1a-9a7d-eeb106ef9553	f	
a1ee7fb1-dbc7-4813-8035-9ee52bca1f5b	bcdf72e1-cb45-4994-bdb2-c0878fcc5ecf	Suhail Maruthil 	784199570531949	562134451	suhailmaruthil@gmail.com	Al Ehtifal Fruits & Vegetables\t	f		2025-06-16 17:52:40.921	2025-06-16 17:52:40.921	S7	NOT_CONFIRMED	2e26c493-9371-403e-89df-9250ac88ae3b	f	
8358a1cb-1d24-4ad3-a8e0-a97aa1b171ff	bcdf72e1-cb45-4994-bdb2-c0878fcc5ecf	Muhammed Riyasudheen 	784198408105751	506374217	riyasudheen5817@gmail.com	Al Ehtifal Fruits & Vegetables\t	f		2025-06-16 17:52:40.921	2025-06-16 17:52:40.921	S8	NOT_CONFIRMED	3e30a142-c5b8-4e03-abe2-cbbbd07b9c5a	f	
562d2643-fbee-4733-ad0a-41bd7ebc3013	6c9e7df1-1912-401d-b067-2fbcb30bf771	Delia Maya 	784199465708123	505169182	deliamapho@gmail.com	Your Destination For Juices\t	f		2025-06-23 10:02:51.792	2025-06-23 10:02:51.792	S14	CONFIRMED	feb0c883-2ed8-4ccb-86f1-65df630e8d6e	f	
5334e3ee-0da9-43fa-a212-afb617159dca	75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	Rashmi Pariyar	784200224117588	0505838552	rashmipry987@gmail.com	McDonald's	f		2025-06-26 12:01:26.497	2025-06-26 12:01:26.497	S6	CONFIRMED	86ec50b4-baaf-4439-b30c-68cf62cb7285	f	
4457ed72-e32b-4518-9757-5718c564342f	75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	Sabin Rai	784200516788054	561005326	sabinbantwarai8@gmail.com		t		2025-06-26 12:01:26.497	2025-06-26 12:01:26.497	S7	CONFIRMED	cb948bc6-adcf-4ef7-a69b-086309301580	f	
910e2a1b-1820-4eaf-a420-be6d12e4ee72	2506ee8e-1255-4be5-bc3f-26800da832b5	Amar Kumar Sharma	784200235829833	527506991		Almarai Emirates Company LLC\t	f		2025-06-18 09:30:30.873	2025-06-18 09:30:30.873	S1	CONFIRMED	1e48d1f3-a433-4b01-9dce-b38c66c47458	f	
8888558c-39c3-42e5-96a2-21a8a46b412b	2506ee8e-1255-4be5-bc3f-26800da832b5	Youstas K C	784200389202399	521453427		Almarai Emirates Company LLC\t	f		2025-06-18 09:30:30.873	2025-06-18 09:30:30.873	S2	CONFIRMED	61082bca-9f33-4f7d-93c0-b871e577ced5	f	
3ae3781e-3529-461d-9af1-ec3397641d11	2506ee8e-1255-4be5-bc3f-26800da832b5	Hassan Ibnushafee	784200289629956	522532476		Almarai Emirates Company LLC\t	f		2025-06-18 09:30:30.873	2025-06-18 09:30:30.873	S3	CONFIRMED	89b56cbc-c457-4bd6-a77d-83ae0223cdd9	f	
96a530c2-fa43-4472-8af2-7083eb1b90aa	2506ee8e-1255-4be5-bc3f-26800da832b5	Nasneem Bavi	784199672804194	568758568		Abdulla Al banna Meat products-Self\t	f		2025-06-18 09:30:30.873	2025-06-18 09:30:30.873	S4	CONFIRMED	e6a94242-8b32-4732-bfc5-3211df76d75e	f	
69115f98-be38-4ecf-bd34-1bdab3d81708	2506ee8e-1255-4be5-bc3f-26800da832b5	Abdul Rasheed	784198913527184	551644200		Family Grocery \t	f		2025-06-18 09:30:30.873	2025-06-18 09:30:30.873	S5	CONFIRMED	244cc615-ac4b-402e-aff3-047865258956	f	
576dd157-9b5d-4d17-a34d-788a2f95ec74	2c25d1dc-2043-40df-95ff-eaf843fdd6fb	Rodalyn Del Castillo Eusebio 	784198614068462	0567044521	msrodalyn@gmail.com	Caboodle Pamper and Play	f		2025-07-01 10:18:09.617	2025-07-01 10:18:09.617	S2	CONFIRMED	e7a28084-aa60-4db1-92a1-95d84fd9ac21	f	
b119e7ae-b002-49bb-80b1-b50f27554fa6	20e47a77-921d-4910-b741-283f35f1781c	Manoj B K	784200188092223	528920706	mg7863149@gmail.com	Top Five Restaurant	f		2025-06-24 06:29:11.634	2025-06-24 06:29:11.634	S1	CONFIRMED	fee44029-b1cd-43ee-92f1-49fff1cec854	f	
5fe84a3c-13a2-4f12-a77a-d465d5bc011a	20e47a77-921d-4910-b741-283f35f1781c	Bishnu BK	784200362758706	551135596	bishnusunar540@gmail.com	Top Five Restaurant	f		2025-06-24 06:29:11.634	2025-06-24 06:29:11.634	S2	CONFIRMED	ca47fbee-28a6-47c4-ae31-d7ad472cc794	f	
aff1d363-ab73-4b8e-9d80-334f28b3a2bf	20e47a77-921d-4910-b741-283f35f1781c	Manoj Singh 	784199612846057	501468375	mahigusain1996@gmail.com	Top Five Restaurant	f		2025-06-24 06:29:11.634	2025-06-24 06:29:11.634	S3	CONFIRMED	b29dcbeb-853c-45c1-8320-0380f584b0a5	f	
f9d688f1-a3d0-4e89-a387-27d328c832b0	20e47a77-921d-4910-b741-283f35f1781c	Shivakumar Kalyani	784197985086079	544117980	shivakumarbaggy@gmail.com	Green Lahore Darbar Restaurant 	f		2025-06-24 06:29:11.634	2025-06-24 06:29:11.634	S4	CONFIRMED	5c868887-fc0d-4c20-a2a5-53177b884096	f	
f7a2ef0d-53b9-46df-8834-f18476cc6ca7	20e47a77-921d-4910-b741-283f35f1781c	Mohammed Mizanur 	784198404609533	561014718	mdmizanchy615@gmail.com	Khaled Restaurant	f		2025-06-24 06:29:11.634	2025-06-24 06:29:11.634	S5	CONFIRMED	88e43af7-7067-42b6-b7eb-bb119b684cca	f	
9cfdc546-ae2d-4986-ab2a-d9c833bced33	20e47a77-921d-4910-b741-283f35f1781c	Zia Ullah Gul 	784199190759805	569227092	jabbar6735300@gmail.com	Ared Alshawarma Cafeteria 	f		2025-06-24 06:29:11.634	2025-06-24 06:29:11.634	S6	CONFIRMED	9ced0105-b6d2-45d4-9477-fabb3994bbbb	f	
2a2918df-6f3a-4168-b876-c431f87e13de	a6fbafb8-1171-46e5-ae8c-c08d1a641971	Jessielyn Malagsogue Bayawan	784199596115701	0509456912	jessielynbayawan8@gmail.com	Cravia	f		2025-06-24 07:52:00.364	2025-06-24 07:52:00.364	S11	CONFIRMED	905b6de2-ca52-4ef1-b276-12949c4aeebb	f	
7309e421-0238-4191-ae77-474c0b344a0a	a6fbafb8-1171-46e5-ae8c-c08d1a641971	Lemuel Remo Vistal	784199780188829	0507156051	lemuelremovistal@gmail.com	Cravia	f		2025-06-24 07:52:00.364	2025-06-24 07:52:00.364	S12	CONFIRMED	6c7c91f0-9d23-45f6-b31c-94d29e4ac5c0	f	
274c0534-e70a-4b00-826d-f214e15ea9c3	a6fbafb8-1171-46e5-ae8c-c08d1a641971	Mark Andrew Mina Maligsay	784199796535427	0504167490	maligsayandrrw@gmail.com	Cravia 	f		2025-06-24 07:52:00.364	2025-06-24 07:52:00.364	S13	CONFIRMED	248e90ca-73d2-405a-b22c-d446c7490e9b	f	
6112ae04-5b17-4900-a08e-e104e5bbb1c1	a6fbafb8-1171-46e5-ae8c-c08d1a641971	karam Singh Kantura 	784197922821836	0505857410	kskaintura555@gmail.com	Fassco Catering Services LLC	f		2025-06-24 07:52:00.364	2025-06-24 07:52:00.364	S14	CONFIRMED	1987c1cc-30f5-4308-897d-6c808cf2f19c	f	
ab01d920-2ac4-4a3e-9476-5534823a171b	2c25d1dc-2043-40df-95ff-eaf843fdd6fb	Jeeva Rajendran 	784200260583404	0508160668	jeevatrp2002@gmailcom	Kumbakom Cafe 	f		2025-07-01 10:18:09.617	2025-07-01 10:18:09.617	S3	CONFIRMED	944e3df2-6318-4fc7-8f61-4dccec8cb44c	f	
2d22c9e4-3087-40c8-9b4f-be80dae21cf7	6c9e7df1-1912-401d-b067-2fbcb30bf771	Chandra Dhoj 	784200330980101	554721478	ganesharyal141@gmail.com	Wood House Restaurant\t	f		2025-06-23 10:02:51.792	2025-06-23 10:02:51.792	S1	CONFIRMED	4410ee96-e182-45e2-b47d-7a2e46cee85e	f	
77993be3-00a3-47e1-b63c-d428eaa99879	04c55980-d280-407c-a641-9171794c50f1	Ramadan Ibrahim					f		2025-06-21 08:35:35.822	2025-06-21 08:35:35.822	S1	CONFIRMED	84fa688c-ab5c-4556-8f5f-03332e39915b	f	
f32588a4-2620-46b8-bffb-8497e9b40246	6c9e7df1-1912-401d-b067-2fbcb30bf771	Bir Bahadur 	784199184940023	561153213	birbdrbk176@gmail.com	Wood House Restaurant	f		2025-06-23 10:02:51.792	2025-06-23 10:02:51.792	S2	CONFIRMED	fcafc2b0-6db5-4bc3-8075-9e8b25aa5543	f	
1c1cef0e-a5d7-46db-831c-8df859a3f707	6c9e7df1-1912-401d-b067-2fbcb30bf771	Sandrine Mboke 	784199441264258	582154626	sandrinemboke77@gmail.com	Salamander Restaurant\t	f		2025-06-23 10:02:51.792	2025-06-23 10:02:51.792	S3	CONFIRMED	2ae26068-d394-4fe1-9d0e-37ffab8f7d27	f	
c7ebe090-050b-4f8e-b101-219ef64948c9	2c25d1dc-2043-40df-95ff-eaf843fdd6fb	Joel Pita Flores 	784199310971355	0551083240	florespitajoel1993@gmail.com	Shawarma Street 	f		2025-07-01 10:18:09.617	2025-07-01 10:18:09.617	S4	CONFIRMED	6fa20174-5e17-4a3a-9801-41eaa57a7cda	f	
5f54d8b1-3f84-42a5-b30b-aa6f1daca1e5	6c9e7df1-1912-401d-b067-2fbcb30bf771	Marco Timonera 	784199080667936	582911481	marcoyabut94@gmail.com	Salamander Restaurant	f		2025-06-23 10:02:51.792	2025-06-23 10:02:51.792	S4	CONFIRMED	857eafe6-fdeb-4552-bee9-68e373c8f6d5	f	
a90ffec7-20b4-492f-a9cf-ab1e4812e868	6c9e7df1-1912-401d-b067-2fbcb30bf771	Sikandar hussain	784199013827086	568128020	ranasikandar87@gmail.com	Sambrial Restaurant	f		2025-06-23 10:02:51.792	2025-06-23 10:02:51.792	S5	CONFIRMED	be0e0951-f4de-4f92-aec6-9604df5b5ad3	f	
01f30cd2-50f1-4086-afb0-e4c527f2bd1d	6c9e7df1-1912-401d-b067-2fbcb30bf771	Raju B K	784200017765809	554644580	rajutaylor30@icloud.com	Trio Cafe	f		2025-06-23 10:02:51.792	2025-06-23 10:02:51.792	S6	CONFIRMED	78d7d1c0-6af4-487c-8ab9-42bf1d8bd3fa	f	
19e851e8-0037-49a6-8b2e-b00a2dd259ba	6c9e7df1-1912-401d-b067-2fbcb30bf771	Lal Kham 	784198333577843	508401149	lal112uae@gmail.com	Shay  Sajha Café \t	f		2025-06-23 10:02:51.792	2025-06-23 10:02:51.792	S7	CONFIRMED	4bb4381e-2f60-43ab-b8b3-99798d7b1d23	f	
b97b47c3-0915-490b-b6fe-8f175d43b975	6c9e7df1-1912-401d-b067-2fbcb30bf771	Sangeetha Nadarasa	784200627445990	562562280	krishnakumarsangeetha2006@gmail.com	Al Sultan Markets and Bakery	f		2025-06-23 10:02:51.792	2025-06-23 10:02:51.792	S8	CONFIRMED	b354ba49-4b84-4289-850d-a07af125aff3	f	
bff5f035-3422-4f64-b3dc-d08f18eaea8f	6c9e7df1-1912-401d-b067-2fbcb30bf771	Suriya Charles 	784199650995774	565679887	suriyacharles193@gmail.com	La Brioche\t	f		2025-06-23 10:02:51.792	2025-06-23 10:02:51.792	S9	CONFIRMED	3942869b-ebb0-497d-bb22-4f95a475fbb8	f	
7a1ba6b8-bd4a-4822-8687-f02668e1b4ac	6c9e7df1-1912-401d-b067-2fbcb30bf771	Christopher Jr 	784199423740044	565605736	christwil2094@gmail.com	Mang Philip Restaurant\t	f		2025-06-23 10:02:51.792	2025-06-23 10:02:51.792	S10	CONFIRMED	321c338e-7cbd-4cde-b914-add6de5ddfd9	f	
9921593e-c23a-4348-b23f-d98dbfb6daa7	6c9e7df1-1912-401d-b067-2fbcb30bf771	Mark Angel 	784199053497444	552321554	akosimarkangelvalle@gmail.com	Mang Philip Restaurant\t	f		2025-06-23 10:02:51.792	2025-06-23 10:02:51.792	S11	CONFIRMED	b2a05525-f3cc-4fc1-aeba-9b9e684699e7	f	
5722db35-566a-4cef-b9e7-ff9fa90a62ec	6c9e7df1-1912-401d-b067-2fbcb30bf771					.	f		2025-06-23 10:02:51.792	2025-06-23 10:02:51.792	S12	CONFIRMED	9bc6df0d-41a7-466d-a7c1-1ba20d5c417b	f	
28524719-6d80-45ff-a817-a36101298bba	3fc70cfb-9bcf-43c7-a229-6102fce06a3e	Mahmoud Ahmed 	784199193070358	507208890	mahmoudjebril863@gmail.com	Roukn Aleatemad Grills \t	f		2025-06-23 10:08:53.419	2025-06-23 10:08:53.419	S1	CONFIRMED	df5e0f76-5cf6-417f-b29c-291caab71417	f	
bb733495-a030-4011-818b-c8f6a7689436	3fc70cfb-9bcf-43c7-a229-6102fce06a3e	Mostafa Safwan 	784200078525324	0582546520	moatfa123m@gmail.com	Roukn Aleatemad Grills	f		2025-06-23 10:08:53.419	2025-06-23 10:08:53.419	S2	CONFIRMED	88516212-f941-45f3-970e-a1f0349b6dba	f	
26b1ab04-ab5b-470a-b1d8-db4a79f0c81f	3fc70cfb-9bcf-43c7-a229-6102fce06a3e	Omran Asri Alhamda	784200341056958	563758861	amranhm770@gmail.com	Al Rowdha Restaurant\t	f		2025-06-23 10:08:53.419	2025-06-23 10:08:53.419	S3	CONFIRMED	536049e0-050d-4db4-a876-705a66c54437	f	
16971e64-ce75-4e97-9d00-e10396c09465	3fc70cfb-9bcf-43c7-a229-6102fce06a3e	Shehab Safwat 	784198487685137	561134628	shehabsafwat539@gmail.com	Al Rowdha Restaurant	f		2025-06-23 10:08:53.419	2025-06-23 10:08:53.419	S4	CONFIRMED	69838e6e-bdce-4559-b660-6f3c9e2bfd31	f	
cf14d7a2-2c98-4f77-a9d0-edea06fe6d4f	3fc70cfb-9bcf-43c7-a229-6102fce06a3e	Ahmed Abdelmohsin 	784199554108680	554354004	ahmedelhag9519@gmail.com	Shay  Sajha Café \t	f		2025-06-23 10:08:53.419	2025-06-23 10:08:53.419	S5	CONFIRMED	2fa1295a-2fe9-4e50-b594-cb626bc6a12d	f	
30e5c454-d4e1-4844-8035-3b45f7cccb22	3fc70cfb-9bcf-43c7-a229-6102fce06a3e	Mohamed Hussein	784198227932187	551644154		Al Bait Al shami Restaurant & cafeteria\t	f		2025-06-23 10:08:53.419	2025-06-23 10:08:53.419	S6	CONFIRMED	ba0906b5-1430-427a-8484-2d65bd297666	f	
619876db-4a09-4132-941a-450868237d81	3fc70cfb-9bcf-43c7-a229-6102fce06a3e	Ahmed Ashraf 	784199567480001	544437284	ahmedelashry971@gmail.com	Al Bait Al shami Restaurant & cafeteria	f		2025-06-23 10:08:53.419	2025-06-23 10:08:53.419	S7	CONFIRMED	df7d0044-4eb7-45ff-a55d-29355d1dce70	f	
9027f45a-0175-4a32-963a-36c61a3804d6	3fc70cfb-9bcf-43c7-a229-6102fce06a3e	Moustafa Mohamed 	784197384165029	509440573		Al Bait Al shami Restaurant & cafeteria\t	f		2025-06-23 10:08:53.419	2025-06-23 10:08:53.419	S8	CONFIRMED	2b4eee07-d6db-48ba-a845-d5716b3b3a3a	f	
0702946e-c4e7-4c9f-a21a-3e5753f404d1	3fc70cfb-9bcf-43c7-a229-6102fce06a3e	Mulu Bekele Gonte	784198905307959	501783887	a1454255354yr@gmail.com	Twon Twenty café\t	f		2025-06-23 10:08:53.419	2025-06-23 10:08:53.419	S9	CONFIRMED	0681964d-49d7-44b8-9259-3b4505b2fa50	f	
2af49951-ceaf-406f-a617-ac416c681d47	2c25d1dc-2043-40df-95ff-eaf843fdd6fb	Chandralekha Boominathan  Arumugam	784199676343819	0555537660	hellonutrition01@gmail.com	Let's Talk Riz Corner Café 	f		2025-07-01 10:18:09.617	2025-07-01 10:18:09.617	S5	CONFIRMED	a7f3869e-361a-4197-ba4e-8458c85c8b03	f	
d51cee58-39a2-4d50-82b3-8abc9e084d28	2c25d1dc-2043-40df-95ff-eaf843fdd6fb	Balamurugan Chinnu 	784199090541352	0586639146	chandraminivlog@gmail.com	Let's Talk Riz Corner Café 	f		2025-07-01 10:18:09.617	2025-07-01 10:18:09.617	S6	CONFIRMED	d3c2920d-3444-40f1-8edf-97a02f0b8eea	f	
1a495061-c5f0-4b94-b01a-20d45a89995f	6dc64863-5b95-4ae8-997c-412fabbd2e3b	Keneth  Dellava 	784200024630509	545543753	darondankeneth@gmail.com	Tierra Café \t	f		2025-06-20 11:00:37.019	2025-06-20 11:00:37.019	S1	CONFIRMED	8d2c46dc-8377-4485-b6fc-ddbfdbbb8cd5	f	
b24b0494-dbd6-4770-a0fa-a35b720000ae	6dc64863-5b95-4ae8-997c-412fabbd2e3b	Alvino Duran	784200039958861	543401387	segundoalvino20@gmail.com	Tierra Café \t	f		2025-06-20 11:00:37.019	2025-06-20 11:00:37.019	S2	CONFIRMED	aad02873-b352-4d75-8b12-1e7a61d7211f	f	
1d5e3841-fc41-4dc1-8604-3bf5225c95f3	6dc64863-5b95-4ae8-997c-412fabbd2e3b	 Kenneth Elcarte Hermoso	784199865982286	506744967	kennethhermoso0104@gmail.com	Tierra Café	f		2025-06-20 11:00:37.019	2025-06-20 11:00:37.019	S3	CONFIRMED	b7533864-9712-4336-b28f-29467fe2095b	f	
6fda4f64-a864-4bf5-a797-672fa42d82b3	6dc64863-5b95-4ae8-997c-412fabbd2e3b	Haris Mathoor 	784199357150590	555397954	harismv706@gmail.com	United private school	f		2025-06-20 11:00:37.019	2025-06-20 11:00:37.019	S4	CONFIRMED	dddc09c2-4a5e-4932-a069-954b2580cb0e	f	
4ab5252c-7684-4be5-834c-8c6ce4d34796	6dc64863-5b95-4ae8-997c-412fabbd2e3b	Levy Labbao Josue	784197858590512	589681958	levylabbaojosue1978@gmail.com	United private school	f		2025-06-20 11:00:37.019	2025-06-20 11:00:37.019	S5	CONFIRMED	badffac7-ef86-4940-b132-3f4a5bd7d68c	f	
6cfd9ccb-ecfe-455e-9d0e-b71107199610	6dc64863-5b95-4ae8-997c-412fabbd2e3b	Rose Tabangay 	784198862337908	526650030	rosetabangay64@gmail.com	United private school\t	f		2025-06-20 11:00:37.019	2025-06-20 11:00:37.019	S6	CONFIRMED	a8ccd446-0f4b-4978-b992-a8078d25037b	f	
d755878c-4cbc-47ed-a26b-059f71030171	6dc64863-5b95-4ae8-997c-412fabbd2e3b	Deepak Rajasekaran	784200212406282	503797448	deepaktam2002@gmail.com	Four Points By Sheraton ,Al ain\t	f		2025-06-20 11:00:37.019	2025-06-20 11:00:37.019	S7	CONFIRMED	d9b3f375-4d06-4233-ab84-dbd339a2f74f	f	
334a3ca6-2754-4ab8-aa81-10b81da08143	6dc64863-5b95-4ae8-997c-412fabbd2e3b	Kalandarsha  Kalara	784199296317490	569532928	kalandarkalara@gmail.com	Four Points By Sheraton ,Al ain\t	f		2025-06-20 11:00:37.019	2025-06-20 11:00:37.019	S8	CONFIRMED	f1b452ae-83f1-4e33-b223-dc53fd0b2195	f	
77e1536b-fc81-44f9-afea-d3b7ac12fb21	6dc64863-5b95-4ae8-997c-412fabbd2e3b	Muhammad Wasim 	784199513098360	507132298	mw327893@gmail.com	Refill Reservce Cafe 	f		2025-06-20 11:00:37.019	2025-06-20 11:00:37.019	S9	CONFIRMED	9169b643-c961-4d6a-bb10-e321e5f7f895	f	
b4269e02-1355-4723-b8cf-db1e2acaa3f6	6dc64863-5b95-4ae8-997c-412fabbd2e3b	Sam Lwanga 	784198239481900	589634041	lwangasam29@gmail.com	Zad Al Khair Catering \t	f		2025-06-20 11:00:37.019	2025-06-20 11:00:37.019	S10	CONFIRMED	073a3b7e-f658-4ec9-bb73-fe6ab6089c11	f	
14ede06b-66c6-425e-9bf8-824009c80af0	6dc64863-5b95-4ae8-997c-412fabbd2e3b	Richard Lwanga	784199149804819	509739974	kadunyarichard@gmail.com	Zad Al khair Catering 	f		2025-06-20 11:00:37.019	2025-06-20 11:00:37.019	S11	CONFIRMED	3324d174-d72f-4c10-8fd2-b3f6c40cefe4	f	
23d11662-8a71-4af4-b2c2-eaf03bba60a2	6dc64863-5b95-4ae8-997c-412fabbd2e3b	Neil Patrick Dela	784199173587165	563307964	neilpatrickbalatbat11@gmail.com	Mang Philip Restaurant\t	f		2025-06-20 11:00:37.019	2025-06-20 11:00:37.019	S12	CONFIRMED	5f58adea-e013-4cb8-8896-ea8cd2d9e9aa	f	
92d55583-4ff2-4ad4-a1cb-27ceacc25cbb	48f9537e-2c16-47ae-9582-98182781c812	Samuel Wole 	784198984200505	552243705	mondoasanmuel@gmail.com	Crownies Tahini and Sweets\t	f		2025-06-20 11:03:37.188	2025-06-20 11:03:37.188	S1	CONFIRMED	46387718-73e7-4ce2-b374-b44255442a63	f	
cdc2d5b6-2052-41c4-b00e-68aa1c068564	48f9537e-2c16-47ae-9582-98182781c812	Fred Jonathan	784198995335803	525091009	fredjonathan@gmail.com	Crownies Tahini and Sweets	f		2025-06-20 11:03:37.188	2025-06-20 11:03:37.188	S2	CONFIRMED	b5dd9687-2f54-47ec-b590-55b8f737de30	f	
8cdab813-74c9-488c-afd9-af28a232f92f	48f9537e-2c16-47ae-9582-98182781c812						f		2025-06-20 11:03:37.188	2025-06-20 11:03:37.188	S3	CONFIRMED	cc8f564b-0f24-4550-9f86-3f08f8a5db33	f	
4c7b4e4b-dc79-47d0-80d9-9ed1a90bde79	3fc70cfb-9bcf-43c7-a229-6102fce06a3e	Abdullah Mubarak 	784197535296822	566782817	bdallhmbarkbnghzy5@gmail.com	Al Qadhi Shaabi Restaurant \t	f		2025-06-23 10:08:53.419	2025-06-23 10:08:53.419	S10	CONFIRMED	c0e7a9a2-a939-43dd-b52a-7260eb937683	f	
c62000e7-335e-460d-8fcb-ce5c013c6c65	3fc70cfb-9bcf-43c7-a229-6102fce06a3e	Mohammed Ali 	784196925963694	506244003		Al Qadhi Shaabi Restaurant	f		2025-06-23 10:08:53.419	2025-06-23 10:08:53.419	S11	CONFIRMED	a586df86-d442-4db5-a677-6c6399c53aa4	f	
40bb7d2f-1ef3-415b-ab98-b4f9454c7189	3fc70cfb-9bcf-43c7-a229-6102fce06a3e					.	f		2025-06-23 10:08:53.419	2025-06-23 10:08:53.419	S12	CONFIRMED	c732f5f0-48a3-4622-8f27-c8debb5dbbf8	f	
8263c514-986f-479a-8192-1b35ef5d0497	3fc70cfb-9bcf-43c7-a229-6102fce06a3e	Mohamed Ahmed	784199271543201	568780254		Harees  Al Majlis Traditional Food\t	f		2025-06-23 10:08:53.419	2025-06-23 10:08:53.419	S13	CONFIRMED	8ef46ed8-4e02-4473-821a-142eb3d25d9f	f	
8ff0a1a4-f13c-4a1b-82e8-e11e3f9a781e	2d623868-3c7e-4603-8fb0-3b057d9aecd3	Rijan Tamang 	784199252392347	0589188503	lama96523@gmail.com	Rebel Foods/ Khalidya 	f		2025-06-20 12:44:36.435	2025-06-20 12:44:36.435	S1	CONFIRMED	7b965a4c-77c8-47a5-829b-e77659d1bfe0	f	
bb104556-1269-4083-8137-008eefb41d7a	2d623868-3c7e-4603-8fb0-3b057d9aecd3	Kapal Singh Samant	784200440844221	0589188503	sounkapil22@gmail.com	Rebel Foods/ Khalidya 	f		2025-06-20 12:44:36.435	2025-06-20 12:44:36.435	S2	CONFIRMED	32773678-69fc-46a4-81d1-439bd28881e2	f	
d94dec29-b5b6-4408-89c2-c6b2e9c05b55	2d623868-3c7e-4603-8fb0-3b057d9aecd3	Jayanta Biswas Jatin 	784199677802169	545542426	jjbiswas730@gmail.com	Monaco Stars and Bars 	f		2025-06-20 12:44:36.435	2025-06-20 12:44:36.435	S3	CONFIRMED	c89fd6d0-3c1c-4c02-92d8-e145cc69eace	f	
eea61dcc-624d-429f-8102-cbbc7e44504c	2d623868-3c7e-4603-8fb0-3b057d9aecd3	Shahid  Mahmood 	784199419719713	525403578	shahidmalik77@yahoo.com	Monaco Stars and Bars 	f		2025-06-20 12:44:36.435	2025-06-20 12:44:36.435	S4	CONFIRMED	baa4f27a-4f02-4884-bf60-99b190b26d54	f	
cd362a9f-c452-4b19-8990-4b4fa253f5e2	2d623868-3c7e-4603-8fb0-3b057d9aecd3	Prossy Miracle Nakkungu	784199748479278	582255639	prossymiracle@gmail.com	Dar Karak & Muhala Restaurant 	f		2025-06-20 12:44:36.435	2025-06-20 12:44:36.435	S5	CONFIRMED	4eb4f77d-8a1d-4789-891a-71b645b7ee31	f	
94ac7691-01a2-43c5-8396-7d0f4aa01232	75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	Viranga Himansi Godawatta K.K	784199714559822	526260050	virangahimansi97@gmail.com	McDonald's	t		2025-06-26 12:01:26.497	2025-06-26 12:01:26.497	S8	CONFIRMED	076984b9-5f10-407f-8b1e-41a27050b940	f	
65d5ee8b-dc9e-4249-8b4c-8b7a727102b6	75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	Disanayaka Mudiyanselage Sarasika Udemali Disanayaka 	784200284771191	508243001	sarasika1129@gmail.com	McDonald's	t		2025-06-26 12:01:26.497	2025-06-26 12:01:26.497	S9	CONFIRMED	ff2c19ba-9500-4569-ad3d-b0246e63256e	f	
da275936-0c19-421a-b5ef-dea80315d07a	75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	Manisha Khatri Bhujel 	784200082438175	0563963102	manishakhatri9090@gmail.com	McDonald's	t		2025-06-26 12:01:26.497	2025-06-26 12:01:26.497	S10	CONFIRMED	e75c74c3-8af3-43ce-8063-72c120e2e6b4	f	
2b8957cd-bef4-4f4c-be6d-26d1d2aef042	75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	Sunita Waiba	784199972033247	567830945	waibashanti10@gmail.com	McDonald's	t		2025-06-26 12:01:26.497	2025-06-26 12:01:26.497	S11	CONFIRMED	b4fd80a0-d186-46b7-9eb0-5b979c84bf44	f	
9e8855ec-a7d5-41d3-b204-10837c9bfb19	75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	 Yubraj Moktan	784200024739367	0506953679	yubrajmoktan83@gmail.com	McDonald's	f		2025-06-26 12:01:26.497	2025-06-26 12:01:26.497	S12	CONFIRMED	0a1bb772-ee94-435b-abf6-b9435b0cf137	f	
442e50e5-7c4c-47b3-93ed-adb5c46e6e72	75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	Mandira Rai	784199760349789	0509431518	binathulung2076@gmail.com	McDonald's	t		2025-06-26 12:01:26.497	2025-06-26 12:01:26.497	S13	CONFIRMED	8fa522df-532b-4f6c-9e44-8fcefaf75ad6	f	
4fa57a56-9c17-4b68-b495-6be2db810ac9	75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	Laxman Bhandari	784199962042851	0529882105	bhandarilaxman5655@gmail.com	McDonald's	t		2025-06-26 12:01:26.497	2025-06-26 12:01:26.497	S14	CONFIRMED	446f53e1-0bdb-475f-b588-d16d89d6dd36	f	
c92d99be-ff8b-4c9e-bfd0-d5664434984a	75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	Sushma Khadka	784200199719889	0554152562	sushma.khadka1419@gmail.com	McDonald's	t		2025-06-26 12:01:26.497	2025-06-26 12:01:26.497	S15	CONFIRMED	9605097a-9554-42f5-9081-eb49a908cbdb	f	
116a280e-a242-43bf-a723-807d089d5d10	2c25d1dc-2043-40df-95ff-eaf843fdd6fb	Mohamoud Abdul  Kader 	784198894738578	0553348148	mmahmmod907@gmail.com	Shawarma Street 	f		2025-07-01 10:18:09.617	2025-07-01 10:18:09.617	S7	CONFIRMED	643df1e6-4cc0-4fa8-be68-389b3dea8604	f	
fc0b5080-eabb-4e6a-aa08-6881d3ff49af	2c25d1dc-2043-40df-95ff-eaf843fdd6fb	Rowina Vazquez Solidum 	784198732229335	0562043127	srowinav@gmail.com	Blossom Hotpot Restaurant	f		2025-07-01 10:18:09.617	2025-07-01 10:18:09.617	S8	CONFIRMED	4d80daf1-5bf2-4a8e-bf8f-87ca9ec6fcec	f	
88a1e247-099f-483b-a1d5-50b038190ca3	2c25d1dc-2043-40df-95ff-eaf843fdd6fb	Abdelsalam  Edelsouky Mohamed	784199700184379	0559454636	noraladinabdaislam@gmail.com	Shawarma Street	f		2025-07-01 10:18:09.617	2025-07-01 10:18:09.617	S9	CONFIRMED	4ff57224-1b8d-42cc-ad51-987d550f92dd	f	
a3dbecb6-1f55-4972-b579-ee72bd08af36	a92bce94-c67f-4943-b247-90103ede8f04	Yani Maerizki	784199232405920	542385366	maerisk92@gmail.com	By Oz Restaurant	f		2025-06-30 06:13:38.258	2025-06-30 06:13:38.258	S15	CONFIRMED	a20b73d2-9056-4d6b-84a8-45905d9f0bd6	f	
37ab7fa2-218c-4b15-9fea-23d7151633cc	826203ed-87ab-4f3e-9cc9-7e41bec15c4e	Isaac Dedjele	784199331365603			Spinco Cleaning Services	t		2025-06-30 07:45:17.079	2025-06-30 07:45:17.079	S1	CONFIRMED	aef38d29-e2fe-4bbe-90cc-7995f73bf632	f	
4ed5f0f7-d7d1-4fea-a30b-9f278f2c32d1	826203ed-87ab-4f3e-9cc9-7e41bec15c4e	Luis Jr Jordan Gohil	784198132515259			Spinco Cleaning Services	f		2025-06-30 07:45:17.079	2025-06-30 07:45:17.079	S2	CONFIRMED	aef38d29-e2fe-4bbe-90cc-7995f73bf632	f	
07363c28-d24b-4bc7-ac43-c3b53f1c2649	826203ed-87ab-4f3e-9cc9-7e41bec15c4e	Parmeshwor Basnet	784197839065253			Spinco Cleaning Services	f		2025-06-30 07:45:17.079	2025-06-30 07:45:17.079	S3	CONFIRMED	aef38d29-e2fe-4bbe-90cc-7995f73bf632	f	
3b4a91d5-a872-48d0-b982-4540e97f6fe8	bcdf98c4-3d84-457b-8111-d841226ac15c					Al Phamed	f		2025-07-05 06:35:37.926	2025-07-05 06:35:37.926	S1	NOT_CONFIRMED	ac224b19-d6c7-4936-8016-290b3ed50f89	f	
7c034bde-254f-4dce-8472-913f3fc6e254	bcdf98c4-3d84-457b-8111-d841226ac15c					Al Phamed	f		2025-07-05 06:35:37.926	2025-07-05 06:35:37.926	S2	NOT_CONFIRMED	e058697e-5df4-4719-ab17-f50d9fe1f7c8	f	
26c8f407-816a-4e44-aee5-e1ae4340c908	bcdf98c4-3d84-457b-8111-d841226ac15c					Al Phamed	f		2025-07-05 06:35:37.926	2025-07-05 06:35:37.926	S3	NOT_CONFIRMED	8cecb125-9d75-4b4c-9134-f50bbd3db171	f	
c005f6f4-bf47-4946-9bfc-6eaf8cca6334	c003f4af-41ce-4fc7-b59e-d3c450556897	Nomer Belen	784199656251933	581179712	nomerbelen@gmail.com	McDonald's	t		2025-06-23 07:54:53.032	2025-06-23 07:54:53.032	S15	CONFIRMED	1db92c02-4262-4924-8190-25352a637b04	f	
a9c8b537-fa6e-4011-ae09-1c0051dcdfcc	c003f4af-41ce-4fc7-b59e-d3c450556897	Puja Gurung	784199483656536	505142068	gurungpuja24@gmail.com	McDonald's	t		2025-06-23 07:54:53.032	2025-06-23 07:54:53.032	S1	CONFIRMED	7ab01bb5-a9dc-4ccb-889e-03537431ef25	f	
19676538-2dfc-40d3-a64e-5e0104a7c642	c003f4af-41ce-4fc7-b59e-d3c450556897	Sakuni Samanmali	784199839988666	581535188	samanmalisaku214126@gmail.com	McDonald's	f		2025-06-23 07:54:53.032	2025-06-23 07:54:53.032	S2	CONFIRMED	be168586-5771-404d-bf87-bfcea184ce83	f	
cddbd42a-28cb-4950-9744-50ed78fd4119	c003f4af-41ce-4fc7-b59e-d3c450556897	Mira Jirel	784200060991567	554970834	mirajirel5@gmail.com	McDonald's	t		2025-06-23 07:54:53.032	2025-06-23 07:54:53.032	S3	CONFIRMED	1a5444b1-fcfe-4c59-8816-161712f2c3f9	f	
2a527234-e0a2-49b5-a36c-14cbd8341be0	c003f4af-41ce-4fc7-b59e-d3c450556897	Devindi Tharunya 	784200196360596	547816516	tharunya.devindi98@gmail.com	McDonald's	t		2025-06-23 07:54:53.032	2025-06-23 07:54:53.032	S4	CONFIRMED	f4b006fe-93e7-4d75-a3db-73dbbdcfbc91	f	
b22c06e2-3357-432e-bc60-1d77051aa84f	c003f4af-41ce-4fc7-b59e-d3c450556897	Tharusika tharaka 	784200184405031	0509894803	Tharusikatharaka40@gmail.com	McDonald's	t		2025-06-23 07:54:53.032	2025-06-23 07:54:53.032	S5	CONFIRMED	06c369a7-05fa-4d8c-8090-b570d85efd95	f	
9274f7e6-0893-479c-b285-f6c1b0add086	c003f4af-41ce-4fc7-b59e-d3c450556897	Manju Tamang	784200214446609	0543972703	tamangshital40@gmail.com	McDonald's	t		2025-06-23 07:54:53.032	2025-06-23 07:54:53.032	S6	CONFIRMED	123b5140-83f5-421a-a182-c83a2b4ee36b	f	
db79f60f-f505-462b-8e21-0ee75b6eb2ee	39c0f7d2-4cf0-4d98-9ce6-d96c1131a522					Wood House Restaurant	f		2025-07-04 10:10:37.708	2025-07-04 10:10:37.708	S1	NOT_CONFIRMED	5c69acca-6091-47cf-9de7-2facfacda9e2	f	
5520965e-5a9f-48b6-aa9c-9ad270c64c17	39c0f7d2-4cf0-4d98-9ce6-d96c1131a522					Wood House Restaurant	f		2025-07-04 10:10:37.708	2025-07-04 10:10:37.708	S2	NOT_CONFIRMED	6f073475-8507-46a7-9411-d5a3635bc104	f	
2f3aae70-c785-4a50-b22b-18b3cf88ccaf	39c0f7d2-4cf0-4d98-9ce6-d96c1131a522					Tierra Cafe	f		2025-07-04 10:10:37.708	2025-07-04 10:10:37.708	S3	CONFIRMED	f3056a3c-8417-404d-beeb-5c6b9ee20405	f	
3d9a56e1-e970-4f3c-9026-14f8f328aec2	0c6de82d-4d6c-47cd-aa90-7cfa1ffe9992	Asmita Rai				Khalidiya Palace Reyhaan by Rotana	f		2025-06-21 08:11:34.43	2025-06-21 08:11:34.43	S1	CONFIRMED	ec29a62c-2eb5-4e0c-9cbe-569b900d216d	f	
c6cc2c3b-bb27-4017-a258-62b7d886d992	0c6de82d-4d6c-47cd-aa90-7cfa1ffe9992	Kshitij Bhurtel				Khalidiya Palace Reyhaan by Rotana	f		2025-06-21 08:11:34.43	2025-06-21 08:11:34.43	S2	CONFIRMED	ec29a62c-2eb5-4e0c-9cbe-569b900d216d	f	
a8a9f557-6a77-4717-be50-cc8c725dcf93	0c6de82d-4d6c-47cd-aa90-7cfa1ffe9992	Laxman Malla				Khalidiya Palace Reyhaan by Rotana	f		2025-06-21 08:11:34.43	2025-06-21 08:11:34.43	S3	CONFIRMED	ec29a62c-2eb5-4e0c-9cbe-569b900d216d	f	
2b290815-be6f-4c26-af77-3ddb06f05108	0c6de82d-4d6c-47cd-aa90-7cfa1ffe9992	Liza Mahrjan				Khalidiya Palace Reyhaan by Rotana	f		2025-06-21 08:11:34.43	2025-06-21 08:11:34.43	S4	CONFIRMED	ec29a62c-2eb5-4e0c-9cbe-569b900d216d	f	
8c53d332-d2f8-4a0c-99ea-d73c07eea08f	0c6de82d-4d6c-47cd-aa90-7cfa1ffe9992	Shiksha Paudel				Khalidiya Palace Reyhaan by Rotana	f		2025-06-21 08:11:34.43	2025-06-21 08:11:34.43	S5	CONFIRMED	ec29a62c-2eb5-4e0c-9cbe-569b900d216d	f	
59d37f28-fcf6-4482-9dba-a40aab4ad1ed	0c6de82d-4d6c-47cd-aa90-7cfa1ffe9992	Lauben Mugisha				Khalidiya Palace Reyhaan by Rotana	f		2025-06-21 08:11:34.43	2025-06-21 08:11:34.43	S6	CONFIRMED	ec29a62c-2eb5-4e0c-9cbe-569b900d216d	f	
d0d0fb33-31c3-41a2-9d79-092ce3246f75	0c6de82d-4d6c-47cd-aa90-7cfa1ffe9992	Rhitik Bajiko				Khalidiya Palace Reyhaan by Rotana	f		2025-06-21 08:11:34.43	2025-06-21 08:11:34.43	S7	CONFIRMED	ec29a62c-2eb5-4e0c-9cbe-569b900d216d	f	
dbec2f84-43b6-4f2f-873c-f610c6a34c2f	0c6de82d-4d6c-47cd-aa90-7cfa1ffe9992	Dan Philip				Khalidiya Palace Reyhaan by Rotana	f		2025-06-21 08:11:34.43	2025-06-21 08:11:34.43	S8	CONFIRMED	ec29a62c-2eb5-4e0c-9cbe-569b900d216d	f	
3b59efae-367b-4e05-b6e0-64d1f51e8da0	0c6de82d-4d6c-47cd-aa90-7cfa1ffe9992	Phool Maya				FASSCO Catering - Danat	f		2025-06-21 08:11:34.43	2025-06-21 08:11:34.43	S9	CONFIRMED	bccf57b5-6d80-4d89-893a-823c5882d574	f	
e155fb4c-122b-4a89-ad0a-0fb1e5a2d8ef	0c6de82d-4d6c-47cd-aa90-7cfa1ffe9992	David Prakash				FASSCO Catering - Danat	f		2025-06-21 08:11:34.43	2025-06-21 08:11:34.43	S10	CONFIRMED	bccf57b5-6d80-4d89-893a-823c5882d574	f	
2f82ed2f-f6c1-4f62-b7cb-87a64d33b82f	0c6de82d-4d6c-47cd-aa90-7cfa1ffe9992	Sajin Thapa				FASSCO Catering - Danat	f		2025-06-21 08:11:34.43	2025-06-21 08:11:34.43	S11	CONFIRMED	bccf57b5-6d80-4d89-893a-823c5882d574	f	
f74aae21-07ea-4228-a533-32af306a481e	0c6de82d-4d6c-47cd-aa90-7cfa1ffe9992	Dipesh Tamang				FASSCO Catering - Danat	f		2025-06-21 08:11:34.43	2025-06-21 08:11:34.43	S12	CONFIRMED	bccf57b5-6d80-4d89-893a-823c5882d574	f	
02dacc91-cc87-49ed-b557-5e31c006c9fc	0c6de82d-4d6c-47cd-aa90-7cfa1ffe9992	Amrit Garti				FASSCO Catering - Danat	f		2025-06-21 08:11:34.43	2025-06-21 08:11:34.43	S13	CONFIRMED	bccf57b5-6d80-4d89-893a-823c5882d574	f	
b7743126-8868-4486-aeeb-dd7220ff1e7c	0c6de82d-4d6c-47cd-aa90-7cfa1ffe9992	Maged Awad				FASSCO Catering - Danat	f		2025-06-21 08:11:34.43	2025-06-21 08:11:34.43	S14	CONFIRMED	bccf57b5-6d80-4d89-893a-823c5882d574	f	
1871f42e-2304-4c10-a280-10e98d5dcedd	39c0f7d2-4cf0-4d98-9ce6-d96c1131a522					Tierra Cafe	f		2025-07-04 10:10:37.708	2025-07-04 10:10:37.708	S4	CONFIRMED	f6fa5ed6-1f51-463e-b1ab-c98777f83bc5	f	
e6fdbb0d-2a8b-41c3-b7a0-ed155ee2ef5a	39c0f7d2-4cf0-4d98-9ce6-d96c1131a522					Tierra Cafe	f		2025-07-04 10:10:37.708	2025-07-04 10:10:37.708	S5	CONFIRMED	e475e467-ce0e-46da-8f89-401481e49c41	f	
4d81ec4e-e3bd-47c2-ab71-137c1a06d2b9	7f271b9d-818b-472d-b5e2-fc9d5a1de59e	Janella Sarmiento Inocencio 	784199872627122	0502587317	inocenciojanella1@gmail.com	Caboodle Pamper and Play	f		2025-06-25 10:43:45.225	2025-06-25 10:43:45.225	S1	CONFIRMED	46e148e5-2071-4fea-a552-7b7af65f0e1f	f	
a4c341dd-3b41-4bdd-a3d3-4135d017e88c	7f271b9d-818b-472d-b5e2-fc9d5a1de59e	Jayramel Aratea Verallo	784198909404034	0543316012	jayramelverallo9@gmail.com	Feather's Cafe 	f		2025-06-25 10:43:45.225	2025-06-25 10:43:45.225	S2	CONFIRMED	4c744a0e-b8c1-41f8-b09e-10053cf7e5f0	f	
798a03a2-ff3e-4fc1-b528-4187e6040e6f	7f271b9d-818b-472d-b5e2-fc9d5a1de59e	Anandhan Raja 	784199058570328	0528702369	anandraja53@gmail.com	Mister Baker 	f		2025-06-25 10:43:45.225	2025-06-25 10:43:45.225	S3	CONFIRMED	ca1ad693-0663-4119-a5a0-4034e6284050	f	
3b0c209d-07cb-4956-af4c-7e3b3d9655ac	7f271b9d-818b-472d-b5e2-fc9d5a1de59e	Mohammed Shifak Salahudeen 	784200069926259	0542525817	shifaakpvt@gmail.com	Monaco Stars and Bars	f		2025-06-25 10:43:45.225	2025-06-25 10:43:45.225	S4	CONFIRMED	2f7f02bc-2642-4a9a-aec5-586dcd162dcb	f	
b1015c13-f2a9-4dbf-a0cf-bb70d04ad702	7f271b9d-818b-472d-b5e2-fc9d5a1de59e	Mohammed Ibrahim Badawy 	784200171363169	0567517352	mahamedebrahem62@gmail.com	Feather's Cafe 	f		2025-06-25 10:43:45.225	2025-06-25 10:43:45.225	S5	CONFIRMED	4ac24787-3b0d-446b-b2b1-b2a111fbc379	f	
d9816133-3f5d-46ed-a5f4-cc6541a29306	7f271b9d-818b-472d-b5e2-fc9d5a1de59e	Amit Siwach Jorawar 	784199168491761	0544300484	amitsiwach99@gmail.com	Monaco Stars and Bars	f		2025-06-25 10:43:45.225	2025-06-25 10:43:45.225	S6	CONFIRMED	e9b86738-8401-412d-aa0a-7baa65a10118	f	
7637318c-e6ed-450a-9df2-221657a53815	7f271b9d-818b-472d-b5e2-fc9d5a1de59e	Mohammad Noufal Patgar 	784199730280304	0527301662	patgarnoufal@gmail.com	Monaco Stars and Bars	f		2025-06-25 10:43:45.225	2025-06-25 10:43:45.225	S7	CONFIRMED	39e5b435-b1da-4527-b677-e09aca7fdde5	f	
edbb7b2d-f33c-4ebf-8719-c82146f61625	7f271b9d-818b-472d-b5e2-fc9d5a1de59e	Ayush Shrestha 	784198759345287	0551433464	ayush@starnbars.ae	Monaco Stars and Bars	f		2025-06-25 10:43:45.225	2025-06-25 10:43:45.225	S8	CONFIRMED	bec594ea-2c18-4041-9541-864019b0a9cf	f	
db838dc4-1614-4d26-b7a9-15b9af2b19b7	6903f207-d73c-4a47-a4e2-2320c81e268f	Abdel Hafez  Abualnadi	784199932516711			Eagle Environmental Services	f		2025-07-01 09:13:49.077	2025-07-01 09:13:49.077	S1	CONFIRMED	7066b770-f768-4777-bdf7-b8bebb598acc	f	
865d810b-f0a0-4d5c-a6de-4ff61272d931	7f271b9d-818b-472d-b5e2-fc9d5a1de59e	Shahid Kamarudeen 	784200371226125	0521829983	shahidshahidk97@gmail.com	Monaco Stars and Bars	f		2025-06-25 10:43:45.225	2025-06-25 10:43:45.225	S9	CONFIRMED	7df1bc7c-c8ea-4046-88fe-91500831686f	f	
696921f4-9720-4930-95a2-b046c4d96e5b	7f271b9d-818b-472d-b5e2-fc9d5a1de59e	Thae Po Po Aung	784199873345203	506404482	thaepopoaung8@gmail.com	Grand Mercure Majilis Residences LLC	f		2025-06-25 10:43:45.225	2025-06-25 10:43:45.225	S10	CONFIRMED	56b282e6-bf0a-43e6-81ff-653c97f31137	f	
cc4278b4-4d9d-479d-abf8-970b7d1d1a12	7f271b9d-818b-472d-b5e2-fc9d5a1de59e	Ashish Gaharwar	784200286712466	569150340	ashishgaharwarchef4@gmail.com	Grand Mercure Majilis Residences LLC	f		2025-06-25 10:43:45.225	2025-06-25 10:43:45.225	S11	CONFIRMED	15da959b-a9db-428e-893c-00a6dd27cb9d	f	
6095648b-e60b-4d63-be6c-31fa983dbf2e	7f271b9d-818b-472d-b5e2-fc9d5a1de59e	Emmanuel Abel Secondo	784199116292709	558060110	emmanuelabel174@gmail.com	Grand Mercure Majilis Residences LLC	f		2025-06-25 10:43:45.225	2025-06-25 10:43:45.225	S12	CONFIRMED	8ee6cffd-5f67-4a5b-9fd7-4b90fd20fbe0	f	
28dea4dd-f063-4d3d-ad3e-22fe56bf1481	39c0f7d2-4cf0-4d98-9ce6-d96c1131a522					Trio cafe	f		2025-07-04 10:10:37.708	2025-07-04 10:10:37.708	S7	CONFIRMED	54413186-00c6-48ea-92e3-4a56ed35d298	f	
83460ede-0bea-4530-b1ea-505f176651f4	fd09836c-43c7-4787-925a-4a6547df9e72	Hamza Shabbir Muhammad	784199438296313	0501688729	hamzamehar1258@gmail.com	Burger Stop Cafeteria	f		2025-06-26 06:26:39.106	2025-06-26 06:26:39.106	S4	CONFIRMED	c90089f7-e8b1-4adf-a707-806524b46d18	f	
ae03e0ee-7298-46d2-98f6-0dea9dc787a5	fd09836c-43c7-4787-925a-4a6547df9e72	Manikantha Ette	784199535425245	502528566	aryanlikith@gmail.com	Burger Stop Cafeteria	f		2025-06-26 06:26:39.106	2025-06-26 06:26:39.106	S5	CONFIRMED	165801e9-c25c-4940-8061-50bdc7933482	f	
b9ecfd20-7160-49b5-89f2-9f863b282a52	fd09836c-43c7-4787-925a-4a6547df9e72	Phanadhar Pun Magar	784199860394032	565953281	tsanjib635@gmail.com	Hinoki restaurant\t	f		2025-06-26 06:26:39.106	2025-06-26 06:26:39.106	S6	CONFIRMED	bb35c535-da25-4580-9d64-b9e44967bf8d	f	
37041c0b-01f9-421b-8fb7-12179c8e9fd7	fd09836c-43c7-4787-925a-4a6547df9e72	Shiva Bhattarai\t\t	784199084702747	501882670	pradeepbhattari47@gmail.com	Crowds Restaurant\t	f		2025-06-26 06:26:39.106	2025-06-26 06:26:39.106	S7	CONFIRMED	e3898109-6655-42ff-afe6-9719cbf7b33f	f	
c2aad047-9aa3-4862-9e51-92a22cda15c4	1c37c6b7-3b0c-4778-ace3-b4b034cff06b	Kunhabdulla Thayyullathil	784197291502967	505692486	anqaabdulla@gmail.com	Al Anqaa Grocery Shop \t	f		2025-06-25 06:12:22.525	2025-06-25 06:12:22.525	S1	CONFIRMED	c8de06b2-c65a-4674-b1f5-24cfa6b8da64	f	
62be83ff-8403-4f39-b2c6-818b045bd8da	1c37c6b7-3b0c-4778-ace3-b4b034cff06b	Ikbal Nalakath	784197570709796	545126643	ikbalkhan600423@gmail.com	Lulu Al Sahra Food Stuff Stores L.L.C\t	f		2025-06-25 06:12:22.525	2025-06-25 06:12:22.525	S2	CONFIRMED	05328e3e-192b-4f9c-83df-b15376fc2cd7	f	
35a00701-26ec-4bd2-84e9-9c90fd71644b	1c37c6b7-3b0c-4778-ace3-b4b034cff06b	Ashraf Vazhayil	784198747080715	562594798	ashrafrana@gmail.com	Lulu Al Sahra Food Stuff Stores L.L.C\t	f		2025-06-25 06:12:22.525	2025-06-25 06:12:22.525	S3	CONFIRMED	3fe2a04b-eeec-44fb-a00b-793a2ea7c939	f	
34816be2-2bda-4ad8-8419-2a1a4fa5415f	1c37c6b7-3b0c-4778-ace3-b4b034cff06b	Mohammed Rinshad 	784200594723478	563909778	rrinshad567@gmail.com	Al Haj Vegetables & Fruits\t	f		2025-06-25 06:12:22.525	2025-06-25 06:12:22.525	S4	CONFIRMED	9ee784a5-a07d-4b23-a130-0be66cb581e0	f	
ee8cc480-9076-479f-9941-afdd349f0733	1c37c6b7-3b0c-4778-ace3-b4b034cff06b	Shuhail Munhanath	784199497258162	545461758	shuhail008@gmail.com	Nassrat Al madena Grocery \t	f		2025-06-25 06:12:22.525	2025-06-25 06:12:22.525	S5	CONFIRMED	68ba13ea-2855-4224-87f2-c1d7814b590d	f	
c490060b-7990-4424-997b-f3bd8b4dbb54	1c37c6b7-3b0c-4778-ace3-b4b034cff06b	Muhammed Shakir 	784199857294237	568508813	shakirmc52677@gmail.com	Nada Al Ain Grocery Shop \t	f		2025-06-25 06:12:22.525	2025-06-25 06:12:22.525	S6	CONFIRMED	d43b8a42-aaa2-48f9-9e44-f8b24e4be212	f	
a8703063-36b3-4a4c-9d27-db0f11270212	1c37c6b7-3b0c-4778-ace3-b4b034cff06b	Fariz Pumadath	784198383715806	543923488	fariz0007@gmail.com	Al Sanafer Grocery \t	f		2025-06-25 06:12:22.525	2025-06-25 06:12:22.525	S7	CONFIRMED	1e93468a-7a30-4ff6-b19d-4b13edb34c16	f	
f4a2ea15-826f-491f-9948-b175999f2085	1c37c6b7-3b0c-4778-ace3-b4b034cff06b	Muhammed Sanoof Ali Kanam	784199990198006	509659941	muhmdsanuff@gmail.com	Al Sanafer Grocery \t	f		2025-06-25 06:12:22.525	2025-06-25 06:12:22.525	S8	CONFIRMED	beae4cdd-a300-494a-831b-d7d1f1bffa19	f	
cbac7dac-65a7-40a5-9c13-297a7963c826	1c37c6b7-3b0c-4778-ace3-b4b034cff06b	Sabeer Thailakandy	784198381852791	551921904	shabee.thailakandy@gmail.com	Eithar Grocery\t	f		2025-06-25 06:12:22.525	2025-06-25 06:12:22.525	S9	CONFIRMED	c5c46fad-b415-482c-921e-cab64573baaa	f	
ccd537e2-baee-4e71-aa81-09c7668f0808	c003f4af-41ce-4fc7-b59e-d3c450556897	Laxmi Tamang	784199759291836	543723462	rumbalaxmi868@gmail.com	McDonald's	t		2025-06-23 07:54:53.032	2025-06-23 07:54:53.032	S7	CONFIRMED	d20ebeff-1314-4f0b-8f65-19228d6b7a32	f	
1efb06d1-6e6a-4a0b-8834-bd61feb3e2b4	c003f4af-41ce-4fc7-b59e-d3c450556897	Sunita Majhi	784200011055769	053264756	majhisunita026@gmail.com	McDonald's	t		2025-06-23 07:54:53.032	2025-06-23 07:54:53.032	S8	CONFIRMED	5c5ec1ad-59a7-4e8c-bd6c-46c24c1faad2	f	
8f3e11cb-4627-4ec5-b628-973e0f99b28a	c003f4af-41ce-4fc7-b59e-d3c450556897	Kamana KC	784200028434999	554973608	kamanakc007@gmail.com	McDonald's	t		2025-06-23 07:54:53.032	2025-06-23 07:54:53.032	S9	CONFIRMED	0245a768-7562-4e04-88a8-cf0fbd5d1d9f	f	
8cc2dc6f-4fab-46aa-9eff-12ff81055953	c003f4af-41ce-4fc7-b59e-d3c450556897	Miguel Eduardo Ayop Ballesteros	784200266650306	509213258	miguellesteross@gmail.com	McDonald's	t		2025-06-23 07:54:53.032	2025-06-23 07:54:53.032	S10	CONFIRMED	681db904-a532-41f9-af47-431b397d812d	f	
9c44cdad-4626-4e57-adc4-bf79592a25df	c003f4af-41ce-4fc7-b59e-d3c450556897	Nadeesha Manahari B. R. R. Mudiyanselage	784200070331481	524337154	nadeeshamb20@gmail.com	McDonald's	t		2025-06-23 07:54:53.032	2025-06-23 07:54:53.032	S11	CONFIRMED	02d74f8c-cb4f-4430-abc8-66adb810074e	f	
084369ec-df48-426b-89a4-b334c65649f5	1c37c6b7-3b0c-4778-ace3-b4b034cff06b	Muhammed Jasir	784200060950209			Alafdaliya General Trading\t	f		2025-06-25 06:12:22.525	2025-06-25 06:12:22.525	S10	CONFIRMED	961645e7-b44d-4e3e-bb5e-b0ffb58fe2c6	f	
8be85db4-7388-4882-b49e-113d2098c9dd	c003f4af-41ce-4fc7-b59e-d3c450556897	Mark John  Prejas Ines	784199810402661	586578115	markjohn.ines18@gmail.com	McDonald's	t		2025-06-23 07:54:53.032	2025-06-23 07:54:53.032	S12	CONFIRMED	f2d3367e-af23-402d-a37b-84930d33fd76	f	
ee73e739-7fa8-4cfd-ad98-d94f0d5f2a0d	c003f4af-41ce-4fc7-b59e-d3c450556897	Mahamad Satar Miya	784199707026094	508176154	mahamadsattar786@gmail.com	McDonald's	t		2025-06-23 07:54:53.032	2025-06-23 07:54:53.032	S13	CONFIRMED	90ef8479-2a76-46d4-9c13-ec041956778c	f	
e576a34e-ac47-4066-bfb5-797e8115db6f	c003f4af-41ce-4fc7-b59e-d3c450556897	Mamita Thapa	784200275529756	543618960	mamitatathapa693@gmail.com	McDonald's	t		2025-06-23 07:54:53.032	2025-06-23 07:54:53.032	S14	CONFIRMED	d79c460b-749e-4b26-8b58-fb39a1ec4097	f	
0d3622f8-b692-42c3-a789-44d79b3835b5	dd94df69-7cc9-40e4-9196-3f2d472eb1c6					Crowds Restaurant\t	f		2025-06-23 06:46:36.781	2025-06-23 06:46:36.781	S6	NOT_CONFIRMED	b3a9dfe8-2dd7-4334-931c-74dd5a20486b	f	
1122393d-cf40-4cdf-b27d-b01b5c637b56	dd94df69-7cc9-40e4-9196-3f2d472eb1c6	Sabir Ali Bhulan	784198684095395	568251239	sabir7652@gmail.com	Madar Alsaah Restaurant & Grill	f		2025-06-23 06:46:36.781	2025-06-23 06:46:36.781	S7	NOT_CONFIRMED	a95cc7a6-b29e-471d-8fa9-fe0a1d99107d	f	
38a745a2-d960-43d0-bfd3-81f98c6a3412	dd94df69-7cc9-40e4-9196-3f2d472eb1c6	SHAMAN ALI JIAND KHAN	784199897536159	566578062	shamanalimalkani@gmail.com	Odore café \t	f		2025-06-23 06:46:36.781	2025-06-23 06:46:36.781	S8	NOT_CONFIRMED	dfa0aa01-0641-483f-a72d-e894fc45985a	f	
dbe3d148-3e46-4cbc-9107-25f570ebc238	dd94df69-7cc9-40e4-9196-3f2d472eb1c6	Mohammad Belal Ansari	784198573061631	521432683	mohammadbelalansari217@gmail.com	AlJeel cafeteria\t	f		2025-06-23 06:46:36.781	2025-06-23 06:46:36.781	S9	NOT_CONFIRMED	97854d7b-f2c8-4b3d-81a9-a05a6faeec56	f	
182b2627-6e50-4c42-b056-006ef165bf84	dd94df69-7cc9-40e4-9196-3f2d472eb1c6	Yasad Khan Shah 	784200263279737	563647121	neikalam1984khan@gmail.com	Jibal Albaraka Restaurant and Kitchen \t	f		2025-06-23 06:46:36.781	2025-06-23 06:46:36.781	S10	NOT_CONFIRMED	d493efe3-e4bc-41a7-8f67-72b5340b992e	f	
b51c8355-7dea-444c-9215-cf2c8a5b9c94	dd94df69-7cc9-40e4-9196-3f2d472eb1c6	Abdul Shakoor 	784198314742903	544043265	abdulshakoor@gmail.com	Sofra Baniyas Restaurant\t	f		2025-06-23 06:46:36.781	2025-06-23 06:46:36.781	S11	NOT_CONFIRMED	4eb42f69-98fa-438b-9588-d4d8a5b344cc	f	
13e5d078-318c-4e3b-95a6-d7b71fe4a994	dd94df69-7cc9-40e4-9196-3f2d472eb1c6	Mohammed Aref 	784199872662608	562745136	moarifansari796@gmail.com	eat and Drink Restaurant\t	f		2025-06-23 06:46:36.781	2025-06-23 06:46:36.781	S12	NOT_CONFIRMED	448c2ee1-e9a1-4065-86f2-51f6ac42b967	f	
4f12e949-0525-46be-a133-e431a290d048	dd94df69-7cc9-40e4-9196-3f2d472eb1c6	Muhammad Adnan Farooq	784200259008660	567864359	a38275530@gmail.com	Al Azhaar Restaurant and Grilled\t	f		2025-06-23 06:46:36.781	2025-06-23 06:46:36.781	S1	NOT_CONFIRMED	66c8f02b-e4b0-44cb-87a7-1b8a34917c55	f	
5a0567e7-35bf-4f32-aac4-a42e5be2576d	dd94df69-7cc9-40e4-9196-3f2d472eb1c6	Hamza Azam kHAN 	784198614373714	523568877	Hamzakhan002012@gmail.com	The Healthy Plate Restaurant\t	f		2025-06-23 06:46:36.781	2025-06-23 06:46:36.781	S2	NOT_CONFIRMED	1f552161-e1f5-4f7e-a406-50ec89e913dc	f	
d6d42f5e-3981-46fe-a2c8-482111208e2d	dd94df69-7cc9-40e4-9196-3f2d472eb1c6	Delwar Hussain 	784199629938863	545671584	delwarrone@gmail.com	Al Rowdha restaurant\t	f		2025-06-23 06:46:36.781	2025-06-23 06:46:36.781	S3	NOT_CONFIRMED	da1b06a8-df21-4c4a-a6b7-7a4d9b136f93	f	
947b6892-48cf-45f5-aca9-a223d7fff1b9	dd94df69-7cc9-40e4-9196-3f2d472eb1c6	Md Shadat Hossan	784199192260141	509586205	ms3179146@gmail.com	Al Rowdha restaurant\t	f		2025-06-23 06:46:36.781	2025-06-23 06:46:36.781	S4	NOT_CONFIRMED	cbcd83b9-0e70-4e4f-acc5-b432fac89b9a	f	
76fa0976-6aec-4ffd-99d6-bf9304085964	dd94df69-7cc9-40e4-9196-3f2d472eb1c6	Shree Narayan Chaudhary	784200056440918	561085480	chaudharynarayan774@gmail.com	Sforno Pizza and Pasta Restaurant	f		2025-06-23 06:46:36.781	2025-06-23 06:46:36.781	S5	NOT_CONFIRMED	718ba1f6-5304-4aa5-9bf4-84c5a7b3b2e9	f	
d9d331b8-928e-47f5-97a4-e6e471655304	dd94df69-7cc9-40e4-9196-3f2d472eb1c6	Mohammad Ibrahim Fazal	784198441492729	559700667	muhammedibrahieam@gmail.com	Mureijb Bakery\t	f		2025-06-23 06:46:36.781	2025-06-23 06:46:36.781	S13	NOT_CONFIRMED	9757fcf7-4b96-4cf6-9511-e4f37f7958b8	f	
b4b73643-6520-4d9b-8724-493efc542b49	fd09836c-43c7-4787-925a-4a6547df9e72	Sanjib Tamang	784199712992975	0566791752	Sanjibtamang1997@gmail.com	\tSforno Pizza and Pasta   Restaurant \t\t	f		2025-06-26 06:26:39.106	2025-06-26 06:26:39.106	S8	CONFIRMED	ce11fc30-aa3b-459b-bb65-c5b24dd942e5	f	
0b55e0f8-6c5a-4d47-8dc6-c7006db312be	fd09836c-43c7-4787-925a-4a6547df9e72	Sachin Shrestha\t	784200537075093	508318872	sachinstha789@gmail.com	Hinoki restaurant\t	f		2025-06-26 06:26:39.106	2025-06-26 06:26:39.106	S9	CONFIRMED	15c87741-ca2c-4147-b979-911bf3a6dee6	f	
0490594a-dcfe-42fe-8742-ff6936c09f83	fd09836c-43c7-4787-925a-4a6547df9e72	Sammu Khan Shakur	784199752902496	558853149	sameer@gmail.com	Al Mafizul Haque Restaurant\t	f		2025-06-26 06:26:39.106	2025-06-26 06:26:39.106	S10	CONFIRMED	c20e6734-2c3b-448b-9861-795009112b95	f	
e819886e-cdc4-4a4d-b9a2-9f924dfb4eb7	fd09836c-43c7-4787-925a-4a6547df9e72	Muhammad Yameen	784198446530606	506689946	m43@gmail.com	Al Remal Thahabeya Restaurant\t	f		2025-06-26 06:26:39.106	2025-06-26 06:26:39.106	S12	CONFIRMED	466817dd-ffb1-4ff6-ba93-2e6945ffb72d	f	
8c40cdf5-0626-4f16-b7c2-808a556227ac	fd09836c-43c7-4787-925a-4a6547df9e72	Usman Inayat Ullah 	784200105465056	565550975	USMANNINAYATULLAH45@GMAIL.COM	Al Azhaar Restaurant and Grilled\t	f		2025-06-26 06:26:39.106	2025-06-26 06:26:39.106	S13	CONFIRMED	d27daced-993f-43f8-8b2e-b1091163724e	f	
01a51ffe-7d25-42ee-bcdf-d45cf6c782c1	09aea980-92a0-4ba5-896f-e3908ce20f4a	Hazem Mohamed	784199897515062			Mohammed Bin Khaled Al Nahyan Generational School	f		2025-07-04 10:11:26.662	2025-07-04 10:11:26.662	S1	CONFIRMED	19d4b87c-33a8-415a-8992-32a4db88b3cd	f	
847255cc-5ea0-4c61-af09-2e232d7af5b0	09aea980-92a0-4ba5-896f-e3908ce20f4a					Mandi Flavor Restaurant	f		2025-07-04 10:11:26.662	2025-07-04 10:11:26.662	S2	CONFIRMED	b8a5044a-c442-43d1-9feb-c94212602ace	f	
ecfca6e8-fe2b-44fc-bbfe-ab867c130f3b	09aea980-92a0-4ba5-896f-e3908ce20f4a					al noor modern bakeryu	f		2025-07-04 10:11:26.662	2025-07-04 10:11:26.662	S3	CONFIRMED	30936aac-92b5-4501-a220-b6bd673bf88e	f	
b16c5f5a-7202-44de-95b9-0405a6a07236	09aea980-92a0-4ba5-896f-e3908ce20f4a					Wood House Restaurant	f		2025-07-04 10:11:26.662	2025-07-04 10:11:26.662	S4	NOT_CONFIRMED	e750d3fa-4fa2-4510-b2ce-dc3d4b2acdf6	f	
43ce53e7-e31b-4a28-a73d-66322b62929f	09aea980-92a0-4ba5-896f-e3908ce20f4a					Wood House Restaurant	f		2025-07-04 10:11:26.662	2025-07-04 10:11:26.662	S5	NOT_CONFIRMED	7b3e94b1-921e-4693-bc3d-2d4feef517ef	f	
e66ef9aa-7cdd-439e-a7bf-186542439d9d	09aea980-92a0-4ba5-896f-e3908ce20f4a					Saraya Halab Restaurant	f		2025-07-04 10:11:26.662	2025-07-04 10:11:26.662	S6	NOT_CONFIRMED	07a36db2-6fce-4322-8b95-f3d5a09abbf6	f	
e2bfa757-eb9b-4fcc-9a6f-f13516fc6361	09aea980-92a0-4ba5-896f-e3908ce20f4a					Saraya Halab Restaurant	f		2025-07-04 10:11:26.662	2025-07-04 10:11:26.662	S7	CONFIRMED	c7e99dc8-a790-4f3c-abca-3f696467c3f3	f	
f83f847e-1605-4fdf-9199-9731f51ef23c	09aea980-92a0-4ba5-896f-e3908ce20f4a			0521333749		Saraya Halab Restaurant	f		2025-07-04 10:11:26.662	2025-07-04 10:11:26.662	S8	CONFIRMED	adc03f01-d828-45d4-b7d4-a7282f9ad37f	f	
b133a9b5-b404-4e93-a082-368a585ef5fa	fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	Upeksha Madhushani J.Yodhapedige	784200247403718	0545931827	madushaniupeksha56@gmail.com	McDonald's	t		2025-06-24 06:12:35.546	2025-06-24 06:12:35.546	S8	CONFIRMED	adad227c-af03-4e82-965a-ed6a2e453ba8	f	
4199d8b7-e1be-4062-ac50-7d66375917ce	fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	Shahin Deshar			shahindeshar60@gmail.com	McDonald's	t		2025-06-24 06:12:35.546	2025-06-24 06:12:35.546	S9	NOT_CONFIRMED	85ead626-8573-476c-b629-81b4e92822f6	f	
8294b135-00cd-48ec-a7f7-d21b22ed7302	fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	Nisha Lama 	784200715478655	0505874734	nisha948328@gmail.com	McDonald's	t		2025-06-24 06:12:35.546	2025-06-24 06:12:35.546	S10	CONFIRMED	064049d7-d508-4139-aef7-d6d1a219a9f5	f	
b37eaa9a-4fee-40db-8967-f377b6ad1b6f	fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	 Sahara Sijali	784200272428663	505741959	sarahgurung555@gmail.com	McDonald's	t		2025-06-24 06:12:35.546	2025-06-24 06:12:35.546	S11	CONFIRMED	5cf663e7-d6fe-4092-8e9d-bd98948fdc1e	f	
31e2539e-69f2-4de8-af85-f5621de600ce	fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	Smriti Maharjan	784200441616891	561054497	smritimaharjan7@gmail.com	McDonald's	t		2025-06-24 06:12:35.546	2025-06-24 06:12:35.546	S12	CONFIRMED	7b373a0b-1340-4cc0-9950-98228ede3008	f	
7f39087d-c527-403d-82a9-9043439cf95a	fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	Sathya Vithakshani P. G. Gamaralalage	784200477013443	555390167	vithakshanis@gmail.com	McDonald's	t		2025-06-24 06:12:35.546	2025-06-24 06:12:35.546	S13	CONFIRMED	f6cf599c-7468-47eb-bbd8-8367b47ce160	f	
06b3fdad-2283-4c68-9838-354333fd06ed	fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	Regine Ladaro Perez	784199195121118	544341731	laderoregine97@gmail.com	McDonald's	t		2025-06-24 06:12:35.546	2025-06-24 06:12:35.546	S14	CONFIRMED	55df6916-abcd-42ca-b463-8e94ec754ae3	f	
d07d697c-d4f9-4c78-87a1-3abbf7ebd5fb	fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	Sushma Ghale	784200141798098	525022982	ghalemenuka82@gmail.com	McDonald's	t		2025-06-24 06:12:35.546	2025-06-24 06:12:35.546	S15	CONFIRMED	18057f7e-3b8a-4b01-a9a0-15597f4f0dde	f	
3f08e1b6-de7d-4710-aab3-6e76881bbeb7	fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	Naresh Shrestha		508804738	nikesh.dshrestha@gmail.com	McDonald's	t		2025-06-24 06:12:35.546	2025-06-24 06:12:35.546	S1	NOT_CONFIRMED	6417cdc7-d098-4e15-89e0-5fa575fc6b48	f	
03b233f6-92ca-42d3-b835-b0afccb64005	fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	Sumudu Ranasinghe	784199438438063	526163881	sumudunisansala000@gmail.com	McDonald's	t		2025-06-24 06:12:35.546	2025-06-24 06:12:35.546	S2	CONFIRMED	a1d6bfd1-2e08-48e0-be46-de0314a9605d	f	
68c08b58-091b-4eaf-8503-904eda26dd73	fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	Rojina Magar	784199631369511	564385699	rojinathapamagar38@gmail.com	McDonald's	t		2025-06-24 06:12:35.546	2025-06-24 06:12:35.546	S3	CONFIRMED	e0b48f4c-c1b1-4d5d-8a6c-1cfe77df62ec	f	
192212bf-79af-4c95-a817-c543faabb534	fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	Mikko Manianga Dela Cruz	784199581345081	501947008	mikko201402@gmail.com	McDonald's	t		2025-06-24 06:12:35.546	2025-06-24 06:12:35.546	S4	CONFIRMED	08d4de9f-27a8-46e8-8fe1-4820586f9052	f	
6ba64f35-2cc8-4ce0-b631-4d484202454d	fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	Jonuel Bongalosa Olivar 	784199931416392	561907876	olivar.jonuel12@gmail.com	McDonald's	t		2025-06-24 06:12:35.546	2025-06-24 06:12:35.546	S5	CONFIRMED	071d5b4c-fea5-4cff-b113-ad63452714e2	f	
c6826621-aa7b-49cf-b885-76b09eacb1a1	fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	Lamin Lama	784200556203667	564733219	lalamin049@gmail.com	McDonald's	t		2025-06-24 06:12:35.546	2025-06-24 06:12:35.546	S6	CONFIRMED	a59b98c4-b018-4235-b87b-e23b26bafec6	f	
0a2de4e8-4a31-41d0-9a83-670444aad744	fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	Yousef Abdullah M.AZaid Alkilani	784200591207418	502752702	ykilani158@gmail.com	McDonald's	t		2025-06-24 06:12:35.546	2025-06-24 06:12:35.546	S7	CONFIRMED	9afd628a-7d6d-45ed-b9e6-343b37708f39	f	
74cba613-1766-43d0-bb74-3f9b37f95a79	a92bce94-c67f-4943-b247-90103ede8f04	Krishnenthu Chalikkuzhimattam 	784199461040000	508721899	krishnenthuvijayan0703@gmail.com	Danat Al Ain Resort \t	f		2025-06-30 06:13:38.258	2025-06-30 06:13:38.258	S1	CONFIRMED	0d5bd195-54bc-4a19-984d-eab3d887f094	f	
e09f4b35-8c22-40ea-afff-5348da16c712	a92bce94-c67f-4943-b247-90103ede8f04	Meer Sohail Ali 	784200190551844	567661347	sohail@gmail.com	Danat Al Ain Resort \t	f		2025-06-30 06:13:38.258	2025-06-30 06:13:38.258	S2	CONFIRMED	4b1b0e5b-1f04-4ba7-bfed-43376c75ead9	f	
632df54c-ca00-4da6-afca-073a49ade32f	a92bce94-c67f-4943-b247-90103ede8f04	Sunil Singh Veer	784199165925209	0562512722	suilarchananegi@gmail.com	Coriander Restaurant \t	f		2025-06-30 06:13:38.258	2025-06-30 06:13:38.258	S5	CONFIRMED	7d55c72c-d134-48bc-a540-3884435f6373	f	
8069651b-fdcb-4c95-8198-851a8d8e1ffe	bcdf98c4-3d84-457b-8111-d841226ac15c					rebel foods	f		2025-07-05 06:35:37.926	2025-07-05 06:35:37.926	S4	NOT_CONFIRMED	cec82f03-3c3f-42eb-97f6-1ecac5909164	f	
e95e576f-9f89-487c-9a3f-047c1683bb71	bcdf98c4-3d84-457b-8111-d841226ac15c					rebel foods	f		2025-07-05 06:35:37.926	2025-07-05 06:35:37.926	S5	NOT_CONFIRMED	44cabd7e-3e98-4e6a-804a-66727ae4d94e	f	
1348b93d-938c-4606-98a6-dc77fd1a25d5	cae29138-7cc5-4834-9d84-eee3f7a7d70a	Sidiq Chullipparambil 	784197002520324	554546107	siddesideeq@gmail.com	Al Mallah Restaurant & Grills\t	f		2025-07-02 06:51:30.468	2025-07-02 06:51:30.468	S1	CONFIRMED	05744924-5242-4b0b-83f8-163094b5ff87	f	
56073d9c-3101-47bf-b4e2-b122f01d05e6	cae29138-7cc5-4834-9d84-eee3f7a7d70a	Muhammed Musthafa	784198151641390	0502004572	musthafaalayattil@gmail.com	Wahat Algaia Restaurant 	f		2025-07-02 06:51:30.468	2025-07-02 06:51:30.468	S2	CONFIRMED	ca3675b1-cecb-4760-b12f-eb2c307d28a6	f	
17aa7719-d5c5-4e9b-96bd-fa41e067daf7	cae29138-7cc5-4834-9d84-eee3f7a7d70a	Mohammed Koorantakath	784198536051810	562602061	muhammedmami718@gmail.com	Al Ramla Alfadhya Restaurant\t	f		2025-07-02 06:51:30.468	2025-07-02 06:51:30.468	S3	CONFIRMED	2a9e0494-4b88-451c-ba43-02a865964ec1	f	
f45e9560-aa66-4f6f-b6db-30a7e14c743d	cae29138-7cc5-4834-9d84-eee3f7a7d70a	Sibi Thomas Baby	784197462714094	528701179	sibi20thomas@gmail.com	Zad Al Khair Catering	f		2025-07-02 06:51:30.468	2025-07-02 06:51:30.468	S4	CONFIRMED	2ee49c70-056b-4a54-a156-d4f04c66a735	f	
2ae89c4c-496f-4186-85ba-887083245b3d	cae29138-7cc5-4834-9d84-eee3f7a7d70a	Sooraj Kumar 	784198153962414	506950883	soorajkumar017@gmail.com	Zad Al Khair Catering	f		2025-07-02 06:51:30.468	2025-07-02 06:51:30.468	S5	CONFIRMED	f9934966-8ed0-4d6d-a757-2399bd0b973e	f	
bb6eb9b2-2dd7-4dd2-8bdb-5d6e3066b0f0	cae29138-7cc5-4834-9d84-eee3f7a7d70a	Rinas Karuvara	784199220392494	567983719	rinaskk228@gmail.com	Al Raya Restaurant	f		2025-07-02 06:51:30.468	2025-07-02 06:51:30.468	S8	CONFIRMED	c5da0384-c10c-449f-a344-35ccd73ea72b	f	
50cd1db4-ce95-4b01-b933-49dea12dd4a3	c1d08a23-7c16-4ca1-8976-cde69d30ffeb	Kaweesha Sewmini Perea	784200430556793	504059724	kaweesha.sewmini7@gmail.com	Gorat Qahwa Café \t	f		2025-06-24 07:15:56.626	2025-06-24 07:15:56.626	S1	CONFIRMED	277b5e10-28f9-46d3-a656-de199ae520ee	f	
dfb6b237-c912-4aef-bfc3-5b26264bae42	c1d08a23-7c16-4ca1-8976-cde69d30ffeb	Marthe Sandra 	784199712456401	522273345	sandramarthe967@gmail.com	Trio Cafe	f		2025-06-24 07:15:56.626	2025-06-24 07:15:56.626	S2	CONFIRMED	d54a55c6-0d76-45e0-8585-b3bfc7095ddb	f	
59dfc9da-0413-4dec-973f-aeed252fae88	c1d08a23-7c16-4ca1-8976-cde69d30ffeb	Sushma Shrestha	784199196464061	506073878	soosaamaashrestha123@gmail.com	Deep Cafe and Roastery 	f		2025-06-24 07:15:56.626	2025-06-24 07:15:56.626	S3	CONFIRMED	1581450a-ae86-4122-a671-15c1af72caa8	f	
2a7a87ce-ac3f-49cd-9592-d9fe649df381	c1d08a23-7c16-4ca1-8976-cde69d30ffeb	Hakim Sewankambo	784199257413171	553987736	sewankambohakim.sh@gmail.com	Walaem Hadramaut Restaurant	f		2025-06-24 07:15:56.626	2025-06-24 07:15:56.626	S4	CONFIRMED	33634a0e-172f-4dbc-8d37-c273b6a9c7ed	f	
79a46cd1-87ef-4407-b59c-57464916cffa	c1d08a23-7c16-4ca1-8976-cde69d30ffeb	Sudip Bhadari	784200427665979	567604723	bhandarisudip479@gmail.com	Just Fresh Juice Cafeteria	f		2025-06-24 07:15:56.626	2025-06-24 07:15:56.626	S5	CONFIRMED	7b29bc63-0d6b-4abf-b56a-5cac94e2fe00	f	
52e03d43-faeb-4b42-a0fa-7352ebfca61b	c1d08a23-7c16-4ca1-8976-cde69d30ffeb	Padam KC	784200182542496	0563441498	padamkhatrI540@gmail.com	Hinoki Restaurant	f		2025-06-24 07:15:56.626	2025-06-24 07:15:56.626	S6	CONFIRMED	99dc0f65-9b0e-4882-a10c-0060b6c2d027	f	
cfabfa3c-6fef-4961-a65f-52de1bd44ade	c1d08a23-7c16-4ca1-8976-cde69d30ffeb	Jordan Alvarez	784198853010977	0528296995	jordanmascunana28@gmail.com	Trio Cafe	f		2025-06-24 07:15:56.626	2025-06-24 07:15:56.626	S7	CONFIRMED	93f6f934-9248-471c-bb96-b14186235b6d	f	
c9699bfc-be19-436c-ad01-83fb23fff630	c1d08a23-7c16-4ca1-8976-cde69d30ffeb	Eric Serrano	784199425319995	0564533952	ercipascual312@gmail.com	Walaem Hadramaut Restaurant	f		2025-06-24 07:15:56.626	2025-06-24 07:15:56.626	S8	CONFIRMED	ecc4a2f3-876e-44f0-8ac6-46cb1b833576	f	
ddee7a54-eb83-42d1-a3e6-c8e31e2b931b	c1d08a23-7c16-4ca1-8976-cde69d30ffeb	Didmus Ngwa Aziwi	784199958913032	554410270	didimusazinwi9@gmail.com	Wood House Restaurant	f		2025-06-24 07:15:56.626	2025-06-24 07:15:56.626	S9	CONFIRMED	ef689b73-2618-44fa-81c7-149466ca5030	f	
035b5e37-9224-4319-a940-67bfff00f503	cae29138-7cc5-4834-9d84-eee3f7a7d70a	Hasanuzzaman Mandayappuram 	784198498586092	544523914	h15488002@gmail.com	Just Silver Cafeteria	t		2025-07-02 06:51:30.468	2025-07-02 06:51:30.468	S9	CONFIRMED	1481cbe2-91cb-4760-86e8-daabd0c2b99c	f	
d436d983-ae95-4d96-ae1b-a036e2279b45	cae29138-7cc5-4834-9d84-eee3f7a7d70a	Muhammed Shanid	784200370229724	551142212	shanidshanu882@gmail.com	Just Break Cafeteria\t	f		2025-07-02 06:51:30.468	2025-07-02 06:51:30.468	S10	CONFIRMED	dee79972-5ea6-4b6a-9943-6568858e1786	f	
a380c492-9760-48be-93fc-518c5f93aa7a	bcdf98c4-3d84-457b-8111-d841226ac15c					rebel foods	f		2025-07-05 06:35:37.926	2025-07-05 06:35:37.926	S6	NOT_CONFIRMED	44cabd7e-3e98-4e6a-804a-66727ae4d94e	f	
7cf16cfd-60fd-446b-b3fa-f75b0b83887f	b31603a5-c3b1-4634-ab59-7991d472803f	Eslam Gamal 	784199593926175	544029591	pealain@pizzaexpress.ae	Pizza Express UAE 	f		2025-06-25 06:00:29.472	2025-06-25 06:00:29.472	S1	CONFIRMED	3b4222bb-4fd1-4e1b-991f-557900248db7	f	
e4264212-0651-4345-a6cd-0b8c94a8bf15	b31603a5-c3b1-4634-ab59-7991d472803f	Manoj Karki	784200046245583	0542874562	manojkarki276@gmail.com	Trio Cafe 	f		2025-06-25 06:00:29.472	2025-06-25 06:00:29.472	S2	CONFIRMED	bb4f3417-e50f-40e5-81bd-50d058922390	f	
e0f3301d-41bd-4884-9170-89e2274cb87c	b31603a5-c3b1-4634-ab59-7991d472803f	Samir Ghising	784200358404554	506063878	sghising031@gmail.com	Trio Cafe 	f		2025-06-25 06:00:29.472	2025-06-25 06:00:29.472	S3	CONFIRMED	179d4b9b-5ac7-43ce-accb-7d718890e51b	f	
94226165-ccf5-4f87-8e8f-463733d54580	ee18c105-2f9f-44e8-8b6c-4a62d7230fcb					Ali Ahmed Refreshment 	f		2025-06-28 11:25:31.392	2025-06-28 11:25:31.392	S1	CONFIRMED	05373cec-72a5-45ce-a099-803ac914c397	f	
4d1f22f2-6bea-4388-94ac-527cdf0f13a9	41bf13ff-1c76-4283-9546-465918ef71bd					Felicita Boutique For  Flowers\t\t	f		2025-07-05 11:08:26.219	2025-07-05 11:08:26.219	S2	CONFIRMED	f22a473e-ca49-4f2c-8456-39f7ea3b5563	f	
d6a81795-48d7-4cf8-9a8d-807abc82c64d	41bf13ff-1c76-4283-9546-465918ef71bd	Marwan Sayed Eid Elsayed Mohamed				Ayla Hotels & Resort	f		2025-07-05 11:08:26.219	2025-07-05 11:08:26.219	S3	CONFIRMED	5d61b45e-1165-445b-b77a-d29a14a2030e	f	
6e150fe0-ff4c-41a9-876a-774298438267	41bf13ff-1c76-4283-9546-465918ef71bd	Anjalee Roshel Akarsha Kotikalage				Ayla Hotels & Resort	f		2025-07-05 11:08:26.219	2025-07-05 11:08:26.219	S4	CONFIRMED	7c39ac88-9eed-4961-bb3f-db85702da6dc	f	
0deaee24-3a0a-4ff7-a240-7269b30eea59	cae29138-7cc5-4834-9d84-eee3f7a7d70a	Muhammed Rafi 	784200182088318	565573942	rafirafithoombayil@gmail.com	Al Haj Fish Trading	f		2025-07-02 06:51:30.468	2025-07-02 06:51:30.468	S12	CONFIRMED	73cb85dc-095a-4a32-8124-0114cda764ff	f	
8882cbdc-bf8c-4802-bf55-f5b7b6d59754	cae29138-7cc5-4834-9d84-eee3f7a7d70a	Afsal Aliyar Aliyar 	784200440725149	555762338	ikkachiachu@gmail.com	Al Noor Modern Bakery	f		2025-07-02 06:51:30.468	2025-07-02 06:51:30.468	S13	CONFIRMED	29324bd9-5837-458c-a2ab-50cbf2bda098	f	
cd4879a1-9357-4843-a6fa-7f9b61745262	cae29138-7cc5-4834-9d84-eee3f7a7d70a	Shahid Matteri	784199910403684	568522443	shahidakd29@gmail.com	Blue Leaf Restaurant	f		2025-07-02 06:51:30.468	2025-07-02 06:51:30.468	S14	CONFIRMED	5e9464b2-c41c-4f3e-8120-6c6713bb84f9	f	
0ec03995-1556-4822-ac4d-8ef3b447221d	5a789dc5-ce40-4fe6-b4bf-b7bbe5c0da33	Sheikh Zaved	784198959583950	566592424	Zavedsheikh070@gmail.com	Top Choice Baqala \t	f		2025-07-02 06:51:45.532	2025-07-02 06:51:45.532	S1	CONFIRMED	321ef2ff-0961-4a6f-961d-4f1309daa414	f	
c1626fd6-0e54-4df0-a9c8-cf308f3b4567	5a789dc5-ce40-4fe6-b4bf-b7bbe5c0da33	Md Abdul kader	784199748325166	567425670	abdulkadermezzi125@gmail.com	Dream Life General Trading\t	f		2025-07-02 06:51:45.532	2025-07-02 06:51:45.532	S2	CONFIRMED	710c8ef8-9923-4e92-aaf8-6f3650fde7ed	f	
c6f38c19-3ea9-4f56-a2e8-7b400ef9a734	51421efe-addf-44bc-930a-15e84da4a314	Manyata Tamang	784200629131374	543736476	manyatatamang53@gmail.com	McDonald's	t		2025-06-25 11:56:11.872	2025-06-25 11:56:11.872	S1	CONFIRMED	1ae0dd04-7a50-4f73-9cfa-180753128981	f	
95560ef2-164b-46a6-9b5d-ecd0ca80bbee	51421efe-addf-44bc-930a-15e84da4a314	Binita Shresta	784199921840908	0508574153	binitastha17@gmail.com	McDonald's	t		2025-06-25 11:56:11.872	2025-06-25 11:56:11.872	S2	CONFIRMED	a3960a87-be6b-427a-a9c1-a7d3ef130cea	f	
e686356a-30fa-48c2-bb26-40bdac946811	51421efe-addf-44bc-930a-15e84da4a314	Manisha Thapa Magar	784200270132291	0542946550	manishatmagar934@gmail.com	McDonald's	t		2025-06-25 11:56:11.872	2025-06-25 11:56:11.872	S3	CONFIRMED	d985aa18-890e-4075-b3a5-ea866b1a0668	f	
ccba8328-b91a-41e4-a562-655dcd421f6c	51421efe-addf-44bc-930a-15e84da4a314	Sarita Gurung	784200054419484	0569753740	gurungsoojin@gmail.com	McDonald's	t		2025-06-25 11:56:11.872	2025-06-25 11:56:11.872	S4	CONFIRMED	5c459c23-7ea1-4536-b120-313d6af7ae47	f	
f949c3dc-98ca-442b-88e9-3a1aafe607de	51421efe-addf-44bc-930a-15e84da4a314	Sabitra  Adhikari	784200011823406	0561056179	sawruadhikari@gmail.com	McDonald's	t		2025-06-25 11:56:11.872	2025-06-25 11:56:11.872	S5	CONFIRMED	b30ec0fd-ee38-45ce-a0e7-79d3af3bb84a	f	
e2cb80f4-2226-486a-a9c2-27142e9060b3	51421efe-addf-44bc-930a-15e84da4a314	Kamala Tamang	784200355927292	0569334829	tamangkamala486@gmail.com	McDonald's	t		2025-06-25 11:56:11.872	2025-06-25 11:56:11.872	S6	CONFIRMED	8f041472-e4e9-413f-b8a6-67a119d093ba	f	
438b52b8-fc18-4058-bb6d-aebbae432086	51421efe-addf-44bc-930a-15e84da4a314	Elisha Gurung	784199614420067	0582045350	elishagurung241@gmail.com	McDonald's	t		2025-06-25 11:56:11.872	2025-06-25 11:56:11.872	S7	CONFIRMED	eb3947e2-26fd-478f-86f2-c1f139ab0fe6	f	
dc929d61-8021-4e31-a256-505a55e27671	51421efe-addf-44bc-930a-15e84da4a314	Batoul Jawdat Hasan	784199793868763	0523394147	BatoulHasan143@gmail.com	McDonald's	t		2025-06-25 11:56:11.872	2025-06-25 11:56:11.872	S8	CONFIRMED	bf88d334-8b9e-4339-b2dc-19f97beec9a7	f	
016ed1ce-0498-4a2b-b16d-0446c537513a	51421efe-addf-44bc-930a-15e84da4a314	Bina  Kumari Panthi	784199836431405	561038851	beenapanthi@gmail.com	McDonald's	t		2025-06-25 11:56:11.872	2025-06-25 11:56:11.872	S9	CONFIRMED	90f19fd4-924f-42b5-baf0-a612015f61c4	f	
0e7e22a8-ea4a-4a08-a04a-44f2e1a39afe	51421efe-addf-44bc-930a-15e84da4a314	Ma Carla Roman	784199269163640	0563298942	macarlaroman1092@gmail.com	McDonald's	t		2025-06-25 11:56:11.872	2025-06-25 11:56:11.872	S10	CONFIRMED	14cb8431-ce6c-4e1c-acac-032e546c03c7	f	
43281f69-cb69-4cca-bf8b-2cd24cb6a8bc	51421efe-addf-44bc-930a-15e84da4a314	Sushmita Waiba	784200266057601	0563297356	tamangsushmita1990@gmail.com	McDonald's	t		2025-06-25 11:56:11.872	2025-06-25 11:56:11.872	S11	CONFIRMED	a4124930-6ba3-4971-ab9e-95fc8b9d904d	f	
3eec8671-ed02-407f-b311-221df6655181	51421efe-addf-44bc-930a-15e84da4a314	Shadini Kavisha Gedara	784200557274626	501867179	shadini.gunasekara@icloud.com	McDonald's	t		2025-06-25 11:56:11.872	2025-06-25 11:56:11.872	S12	CONFIRMED	5b5107b6-1eb4-47b3-913a-7d974dcf440a	f	
1c571883-bfef-47bc-add2-ac064138dd2a	5a789dc5-ce40-4fe6-b4bf-b7bbe5c0da33	Mohammed Nurun Nabi	784198163182409	567259956	mdnurnobiuae02@gmail.com	Special Touch Meat and Fish Trading\t	f		2025-07-02 06:51:45.532	2025-07-02 06:51:45.532	S3	CONFIRMED	d15e37b7-4f16-4441-ac0c-bac932e03479	f	
ba7e4dfb-7296-436d-b774-1e28f2eca72e	5a789dc5-ce40-4fe6-b4bf-b7bbe5c0da33	Alahi Hoque	784198990390795	559720275	alahehouque786@gmail.com	Ishq Grocery	f		2025-07-02 06:51:45.532	2025-07-02 06:51:45.532	S4	CONFIRMED	c0c1eaa0-0994-48f6-bbda-56cfead3cacc	f	
11ec2fe0-5a11-4112-a00f-8622041e0dc6	5a789dc5-ce40-4fe6-b4bf-b7bbe5c0da33	Md Rakibul Hoq	784200431958519	504720449	rakibulhuque750@gmail.com	World Gate Baqala 	f		2025-07-02 06:51:45.532	2025-07-02 06:51:45.532	S5	CONFIRMED	af010fce-9d69-4d5c-a0fd-56f20dbdd928	f	
6dae8557-9d5c-4aa1-8c7a-f2991ee4b74a	5a789dc5-ce40-4fe6-b4bf-b7bbe5c0da33	Mohd Salman Ishteyaq	784200071486664	504142217	msalmanazmi72@gmail.com	Zahrathul Murijib grocery \t	f		2025-07-02 06:51:45.532	2025-07-02 06:51:45.532	S6	CONFIRMED	0d9de9c0-fd54-4ce9-80ae-abdcbe4b97f1	f	
077b8167-e3dd-4483-bf3e-660a52a092e7	5a789dc5-ce40-4fe6-b4bf-b7bbe5c0da33	Mohammad Jakir Hossain	784199036938191	543843923	jh309598@gmail.com	Twister one Grocery	f		2025-07-02 06:51:45.532	2025-07-02 06:51:45.532	S7	CONFIRMED	35d7d1b5-75ab-40d4-a074-14194833323f	f	
5404e95f-1f17-439e-b060-f9d876474b3e	51421efe-addf-44bc-930a-15e84da4a314	Subin Shrestha	784199851905945	0561052965	subinshrestha015@gmail.com	McDonald's	t		2025-06-25 11:56:11.872	2025-06-25 11:56:11.872	S13	CONFIRMED	edd5e6df-3053-4168-903e-dac98c21f40f	f	
cb687e36-b52d-4e91-a900-ae44cee13ee0	51421efe-addf-44bc-930a-15e84da4a314	Shishir Tamang	784199358485169	0544918460	tamangsisir83@gmail.com	McDonald's	t		2025-06-25 11:56:11.872	2025-06-25 11:56:11.872	S14	CONFIRMED	40b404a8-3dbe-43c0-8b3d-93e4d3e06795	f	
4decabfc-2bab-4e53-8918-137be87d4d35	51421efe-addf-44bc-930a-15e84da4a314	Cloyd Crebello Robles	784199471865891	547563226	cloydrobles23@gmail.com	McDonald's	t		2025-06-25 11:56:11.872	2025-06-25 11:56:11.872	S15	CONFIRMED	54fbb4b6-c51e-41f3-b44a-577130783c86	f	
47c86012-17d4-42df-b85a-d84e69ec3db1	a3f8a171-6fea-4c4d-adab-174a2b1b55c7					Unimar Building Cleaning Services	f		2025-06-25 11:56:29.336	2025-06-25 11:56:29.336	S1	CONFIRMED	bfa61ecf-c0e5-4c55-85b7-463b8360ecba	f	
759973c7-d4ba-4cb6-b0e3-f355d10ed42f	a3f8a171-6fea-4c4d-adab-174a2b1b55c7					Unimar Building Cleaning Services	f		2025-06-25 11:56:29.336	2025-06-25 11:56:29.336	S2	CONFIRMED	bfa61ecf-c0e5-4c55-85b7-463b8360ecba	f	
fbcabb91-3dbe-41b4-be64-98124bc24ada	41bf13ff-1c76-4283-9546-465918ef71bd					Tierra Café	f		2025-07-05 11:08:26.219	2025-07-05 11:08:26.219	S6	CONFIRMED	1855dbbf-0c07-48ad-a7ab-57dd10d078ee	f	
695b1577-2158-4290-bd45-4262fffc6f9f	41bf13ff-1c76-4283-9546-465918ef71bd					Tierra Café	f		2025-07-05 11:08:26.219	2025-07-05 11:08:26.219	S7	CONFIRMED	ec53b5c8-1a61-4eaf-b91a-ed34ec7bc85f	f	
3940c7d2-291e-4df0-af3b-34cbeb4996df	41bf13ff-1c76-4283-9546-465918ef71bd					Tierra cafe	f		2025-07-05 11:08:26.219	2025-07-05 11:08:26.219	S8	CONFIRMED	52f9e915-e4cf-4106-8f65-3a1661237867	f	
d44bb8b6-2e41-4e3c-a726-aeb12e493a3b	41bf13ff-1c76-4283-9546-465918ef71bd					Lamars rest and café	f		2025-07-05 11:08:26.219	2025-07-05 11:08:26.219	S10	CONFIRMED	a0cca297-6114-4c54-aa11-74928baa25e8	f	
229c7291-3947-4c70-b7f2-6e2c75b04ae6	7003baa5-f4fd-4046-8616-c262bb72f1c6	Prakash Gurung	784199064370614	569204467	grgprakashata@gmail.com	Typing coffee shop\t	f		2025-07-05 06:41:03.469	2025-07-05 06:41:03.469	S3	CONFIRMED	0bfc4413-0e51-4860-9432-cac1bc6c20db	f	
5f711d09-35bb-4b78-8429-0a9646042b81	41bf13ff-1c76-4283-9546-465918ef71bd					Lamars rest and café	f		2025-07-05 11:08:26.219	2025-07-05 11:08:26.219	S11	CONFIRMED	af5771de-e377-436c-9dfd-4b45c780cf9f	f	
cf7f1d02-3f8c-4bb2-a06a-3775829eccf9	7003baa5-f4fd-4046-8616-c262bb72f1c6	Von Vangel	784199398358707	562153269	mahenzu09@gmail.com	Feather Cafe	f		2025-07-05 06:41:03.469	2025-07-05 06:41:03.469	S4	CONFIRMED	0b224caf-b92e-4c09-bcdb-45f19c490e04	f	
30f502cf-6d26-420d-adb5-2adb82ab7a04	c65f2289-efa4-4773-9d49-3900f0bd95ff	Md Johir Uddin	784199082356462	566742773	bachu3656@gmail.com	Aldalwo Alfedi Food stuff Trading	f		2025-07-04 11:47:29.643	2025-07-04 11:47:29.643	S1	CONFIRMED	a34c39fc-f081-4ef7-a782-2d5d4f040bd5	f	
46938aba-1e2a-4de8-a3d5-058c77ce214e	c65f2289-efa4-4773-9d49-3900f0bd95ff					km trading	f		2025-07-04 11:47:29.643	2025-07-04 11:47:29.643	S2	NOT_CONFIRMED	f5035444-72a5-4e4c-9891-d20492913fa0	f	
125bcfbc-c019-4e82-b146-bb199fcd6af8	c65f2289-efa4-4773-9d49-3900f0bd95ff					km trading	f		2025-07-04 11:47:29.643	2025-07-04 11:47:29.643	S3	NOT_CONFIRMED	852b1117-0f24-485a-a429-14e0313e5b4b	f	
5f520090-61f3-4886-bdd8-9727385fd7e8	c65f2289-efa4-4773-9d49-3900f0bd95ff					km trading	f		2025-07-04 11:47:29.643	2025-07-04 11:47:29.643	S4	NOT_CONFIRMED	47b0b9ae-3c03-4e91-b8b7-937ba6dbc100	f	
b9248f98-0d7f-418e-b02d-f178e4ce44c9	7003baa5-f4fd-4046-8616-c262bb72f1c6	Sasanka Akash Sanjeewa	784199785346190	568949531	sasankaakash97@icloud.com	Feather Cafe	f		2025-07-05 06:41:03.469	2025-07-05 06:41:03.469	S5	CONFIRMED	c9a4bd90-6787-4623-8dc6-2da094964c89	f	
feb02ddf-cd73-40a7-a390-02db223358c3	7003baa5-f4fd-4046-8616-c262bb72f1c6	Pradeep Kishor	784200394825424	563325044	kishorkaoushanth28@gmail.com	Feather Cafe	f		2025-07-05 06:41:03.469	2025-07-05 06:41:03.469	S6	CONFIRMED	de60d1d8-12b2-47f7-b55e-c83a4ed1ba0d	f	
3e6b5e21-00bf-4071-bfa2-320a27256121	7003baa5-f4fd-4046-8616-c262bb72f1c6	Rodelio Jr Guinto	784198284838806	545802196	rodelio0610@icloud.com	Trio Cafe	f		2025-07-05 06:41:03.469	2025-07-05 06:41:03.469	S7	CONFIRMED	6418e9d1-028d-4727-95bc-c1bf54463a37	f	
a2083cb4-5f58-4669-88b5-9390692c6b40	7003baa5-f4fd-4046-8616-c262bb72f1c6	Kevin Clyde	784199851632754	561871845	belenkevinclyde1998@gmail.com	Trio Cafe	f		2025-07-05 06:41:03.469	2025-07-05 06:41:03.469	S8	CONFIRMED	93f00836-f84f-4f09-bf24-c1f2b6d91147	f	
d9c86e52-c1a7-49c7-a6f0-7e25a0202616	7003baa5-f4fd-4046-8616-c262bb72f1c6	Chathura Rukshan 	784200023094079	529304793	rukshanchithalka@gmail.com	Piece of Café	f		2025-07-05 06:41:03.469	2025-07-05 06:41:03.469	S9	CONFIRMED	10dacd06-2921-455e-8f40-be008bbd0015	f	
84228bff-c742-4bf9-9569-09365681c6b3	7003baa5-f4fd-4046-8616-c262bb72f1c6	Mireal Cajuban	784199871212371	566044390	realmicajubanllano@gmail.com	Piece of Café	f		2025-07-05 06:41:03.469	2025-07-05 06:41:03.469	S10	CONFIRMED	e892208b-801f-45b8-8134-a7b45884559c	f	
d56969a1-56d9-47f4-b30f-fe2177c1ec35	a92bce94-c67f-4943-b247-90103ede8f04	Ayush Rawat Ramesh	784200299009835	0528155459	ar368247@gmail.com	Coriander Restaurant \t	f		2025-06-30 06:13:38.258	2025-06-30 06:13:38.258	S6	CONFIRMED	087ed0d7-2a3a-449e-854d-b618091b6171	f	
b1ecc09e-11fe-40f4-9d24-124b485d33b1	a92bce94-c67f-4943-b247-90103ede8f04	Giselle Putong 	784199369651601	0505037428	giselle03tejero@gmail.com	Delicacy Vita Flowers and Sweets\t	f		2025-06-30 06:13:38.258	2025-06-30 06:13:38.258	S7	CONFIRMED	6a9a0480-a054-42a2-aa11-1a41e7d1ae03	f	
616dc9ff-8b7f-4126-9635-81bcd7841035	a92bce94-c67f-4943-b247-90103ede8f04	Neil Cantor 	784198797241837	524179185	neilgersalia1987@gmail.com	SKW Café \t	f		2025-06-30 06:13:38.258	2025-06-30 06:13:38.258	S8	CONFIRMED	a7e63f29-f0f8-4270-8453-1cd35a695d12	f	
fe021f22-dd4e-493d-9eb9-6c4cf2f2dfae	a92bce94-c67f-4943-b247-90103ede8f04	Jonathan Castillo	784198084875248	553728476	jonathanbartolome321@gmail.com	Al Barjeel Restaurant\t	f		2025-06-30 06:13:38.258	2025-06-30 06:13:38.258	S9	CONFIRMED	619d13d0-7b89-4c42-8ee0-8bc7f8aa2ac8	f	
0a221af4-5783-4b9c-bbf6-d8dece7fce4b	a92bce94-c67f-4943-b247-90103ede8f04	Dominique Cabarteja	784199696100009	0559885339	nhiqueubana09@gmail.com	Mang Philip Restaurant \t	f		2025-06-30 06:13:38.258	2025-06-30 06:13:38.258	S10	CONFIRMED	28f8c777-9792-48ec-9e6c-f432a2d45d11	f	
5590cad6-d023-46b6-baaf-a5daa3cfcfec	a92bce94-c67f-4943-b247-90103ede8f04	Ashok Kumar 	784199686624661	0564591931	ash0564591931@gmail.com	On the Block Cafe	f		2025-06-30 06:13:38.258	2025-06-30 06:13:38.258	S13	CONFIRMED	51fbfbd2-25e2-4afd-8c78-deae3ecb742f	f	
dcb02c8d-f29d-49d3-9ad2-96827ada5f04	a92bce94-c67f-4943-b247-90103ede8f04	Christopher Lavina	784199651831663	586607581	christopherabing@gmail.com	Al Barjeel Restaurant\t	f		2025-06-30 06:13:38.258	2025-06-30 06:13:38.258	S14	CONFIRMED	df744b1b-2cb3-4dac-b2ce-de04f86be6da	f	
c11b99dd-74e1-4b2d-ae8c-4d6e2262fc04	7003baa5-f4fd-4046-8616-c262bb72f1c6	Gina Lasay	784198692147584	567836345	ginajunasa44@gmail.com	Harees Alfarej Restaurant \t	f		2025-07-05 06:41:03.469	2025-07-05 06:41:03.469	S11	CONFIRMED	a67c539d-8293-426c-aa94-7cc82d12ccca	f	
5b612162-1917-4a7b-8a68-ceb940481885	7003baa5-f4fd-4046-8616-c262bb72f1c6	Dilusha Wijayanga	784200635611708	569597816	dilishavijayanga64@gmail.com	Harees Alfarej Restaurant \t	f		2025-07-05 06:41:03.469	2025-07-05 06:41:03.469	S12	CONFIRMED	fc64f4b6-90d3-4efa-a094-9dff473938d4	f	
b44dba63-c43f-4ace-9563-d4bdf0217ec4	41bf13ff-1c76-4283-9546-465918ef71bd					Tierra Cafe 	f		2025-07-05 11:08:26.219	2025-07-05 11:08:26.219	S5	CONFIRMED	049f164e-4b89-4c0d-85f6-0eb550d523b1	f	
75c88614-e687-47ca-824b-2397e6154982	41bf13ff-1c76-4283-9546-465918ef71bd	Limuel Guevarra 	784198757305036	0551553795		Tierra Cafe	f		2025-07-05 11:08:26.219	2025-07-05 11:08:26.219	S14	CONFIRMED	815d6061-9270-4f98-a4db-0b65009f460a	f	
6d7dacc5-be05-4505-b628-e18293b7d4c8	41bf13ff-1c76-4283-9546-465918ef71bd	Sainath Ette Srichandram 	784199493924072			Tierra Cafe	f		2025-07-05 11:08:26.219	2025-07-05 11:08:26.219	S15	CONFIRMED	76daa9c8-453b-4555-9ae8-9f7db8e7400d	f	
163969df-6eeb-4378-a7f8-40ee482d5d22	7003baa5-f4fd-4046-8616-c262bb72f1c6	Sanjaya Shrestha	784199185246503	568931246	sanjayashrestha093@gmail.com	Harees Alfarej Restaurant \t	f		2025-07-05 06:41:03.469	2025-07-05 06:41:03.469	S13	CONFIRMED	0a6c0562-84e5-467e-bdba-ce4951725f8c	f	
f27691bb-35d1-4fdb-8218-f3afaf4f024d	7003baa5-f4fd-4046-8616-c262bb72f1c6	Sudeep Chetthri	784199986890947	503098066	sudeepchhetri41@gmail.com	Diet Station Restaurant	f		2025-07-05 06:41:03.469	2025-07-05 06:41:03.469	S1	CONFIRMED	9c52dcdc-88e4-495d-bada-3e09bdf1d381	f	
2893fe32-526b-4e4a-9335-fced0fcfd4ff	41bf13ff-1c76-4283-9546-465918ef71bd					On the Block Cafe	f		2025-07-05 11:08:26.219	2025-07-05 11:08:26.219	S12	CONFIRMED	35e1eef4-3410-4e08-bb22-3faee8cd671e	f	
a798efd7-1a7a-4f07-90af-f3275e20ef54	d3461489-a74d-441b-87d5-d8155fc06768					Tierra Cafe	f		2025-07-04 10:14:17.249	2025-07-04 10:14:17.249	S1	CONFIRMED	83d52a13-a52f-4208-9b59-fd7a39ab44ba	f	
e55b2ca4-b0eb-4b0c-8687-6c1a6d389df9	d3461489-a74d-441b-87d5-d8155fc06768					Tierra cafe	f		2025-07-04 10:14:17.249	2025-07-04 10:14:17.249	S2	CONFIRMED	f57be3b9-7c3d-4316-b1f8-2455a4dbeee0	f	
6011f149-4f0f-4f24-8568-1228bf71cb66	d3461489-a74d-441b-87d5-d8155fc06768					Tierra Cafe	f		2025-07-04 10:14:17.249	2025-07-04 10:14:17.249	S3	CONFIRMED	9cf1b65d-5941-4e0f-9f63-22701a9c07ba	f	
a4336c29-85bb-4ce5-af5d-740be9b64cc1	d3461489-a74d-441b-87d5-d8155fc06768					Tierra cafe	f		2025-07-04 10:14:17.249	2025-07-04 10:14:17.249	S4	CONFIRMED	cded10e7-07d9-481f-b785-1ab5fa9b8df7	f	
ed221acf-7962-493d-bd88-dc7c25f0ccac	d3461489-a74d-441b-87d5-d8155fc06768					Tierra Cafe	f		2025-07-04 10:14:17.249	2025-07-04 10:14:17.249	S5	CONFIRMED	448a3569-0457-4c22-a157-49805c9fde4f	f	
833972a7-3094-4194-bbe1-96e160d6bac6	d3461489-a74d-441b-87d5-d8155fc06768					Tierra Cafe	f		2025-07-04 10:14:17.249	2025-07-04 10:14:17.249	S6	CONFIRMED	ffe0bdb1-dfa6-4d5e-845b-d4a3faf3248c	f	
b0478128-1687-4df1-a2a1-e453f1a2d82d	d3461489-a74d-441b-87d5-d8155fc06768					Feather Cafe	f		2025-07-04 10:14:17.249	2025-07-04 10:14:17.249	S9	CONFIRMED	8663dc51-7b15-473f-a39a-8d8e0e2f70a9	f	
a44d75d3-2db6-4dd5-a366-249a7112574a	5bca0cf0-431a-4302-b552-e06e16182b67					Unimar Building Cleaning Services	f		2025-06-25 11:57:44.514	2025-06-25 11:57:44.514	S1	CONFIRMED	bfa61ecf-c0e5-4c55-85b7-463b8360ecba	f	
79547e4a-5fbf-4193-8729-85a037772ff5	5bca0cf0-431a-4302-b552-e06e16182b67					Unimar Building Cleaning Services	f		2025-06-25 11:57:44.514	2025-06-25 11:57:44.514	S2	CONFIRMED	bfa61ecf-c0e5-4c55-85b7-463b8360ecba	f	
2fd6b84a-ff34-4d60-91c5-5b4585e994a4	f03f9394-e306-49e9-aac3-6473745aad38	Emeliza Gabrino Merculio	784198659847606	0588723693	emelizagabrino@gmail.com	Green House 	f		2025-06-26 05:01:19.586	2025-06-26 05:01:19.586	S5	CONFIRMED	93934fd6-67dc-4df4-9876-11fae659fdc3	f	
f7af3c22-14a1-407f-9c1e-35b8d1b94b09	f03f9394-e306-49e9-aac3-6473745aad38	Muhammad Danish Khan 	784199958057327	0588485064	sardardanishkhan123@gmail.com	Gyma  Food Industries 	f		2025-06-26 05:01:19.586	2025-06-26 05:01:19.586	S6	CONFIRMED	9d945b72-3673-4740-ac06-4fbd6f486480	f	
95621aff-c605-4863-ae06-cab3df970a8d	f03f9394-e306-49e9-aac3-6473745aad38	Naeema  Nihala Vadakkanazhi	784200290976727			Personal  	f		2025-06-26 05:01:19.586	2025-06-26 05:01:19.586	S2	CONFIRMED	1c10433b-0080-404e-8943-98df4a322457	f	
50fef2da-caa3-49b9-ab6b-ab6548843328	f03f9394-e306-49e9-aac3-6473745aad38	Nifal  Mohammed Ullal 	784200076366440	0508758044	nifalmohammed8@gmail.com	Green House 	f		2025-06-26 05:01:19.586	2025-06-26 05:01:19.586	S3	CONFIRMED	92db1fdc-73c1-4ff0-a074-b69eab125401	f	
e1c23525-8ce2-4749-8d8e-07cb0073a986	f03f9394-e306-49e9-aac3-6473745aad38	Analyn Paraguison De Guzman	784198587627161	0502864153	deguzmananne413@gmail.com	Green House 	f		2025-06-26 05:01:19.586	2025-06-26 05:01:19.586	S4	CONFIRMED	b224dbe3-d56f-4c66-ad43-7ae32c3a0718	f	
12ddb5dc-26f4-4c56-800f-d6e9cabf35bd	f03f9394-e306-49e9-aac3-6473745aad38	Wilbelle Ramos Valencio		0508710687	wilbellevalencia@gmail.com	Patchi 	f		2025-06-26 05:01:19.586	2025-06-26 05:01:19.586	S1	CONFIRMED	e2dca5a8-9207-4a1e-892c-9451dbb50cad	f	
a42b6cda-56de-4605-a2de-e24626764b24	57f2b101-ffb6-4649-a03a-74e73e1cf855	Mohamed Basiouny 	784200132101237	561833452	a010188641@gmail.com	Ared Alshawarma  Cafeteria\t	f		2025-06-26 06:02:38.798	2025-06-26 06:02:38.798	S1	CONFIRMED	42ed7e06-5349-4cf3-a15f-b59af9877dcb	f	
0e1558f3-8a98-4bce-8982-6c9e4b3aa0e9	d3461489-a74d-441b-87d5-d8155fc06768					Feather Cafe	f		2025-07-04 10:14:17.249	2025-07-04 10:14:17.249	S10	CONFIRMED	7290a524-2d05-484f-941e-1e5c0d05c294	f	
c18c17c3-9838-4173-8885-867ff1781764	d3461489-a74d-441b-87d5-d8155fc06768					Flamingo Events	f		2025-07-04 10:14:17.249	2025-07-04 10:14:17.249	S11	CONFIRMED	1e7f91a5-eb06-49ea-a2ae-5be2116ee9a8	f	
e2d5a5ff-7a9a-48b6-b57b-c9189c71dcfa	d3461489-a74d-441b-87d5-d8155fc06768					Flamingo Events	f		2025-07-04 10:14:17.249	2025-07-04 10:14:17.249	S12	CONFIRMED	bd1d042b-c81d-4b48-b70a-839ecf3bfc6f	f	
aea11b98-b2e0-436d-9038-99cc03b1b149	d3461489-a74d-441b-87d5-d8155fc06768					Margin Café\t	f		2025-07-04 10:14:17.249	2025-07-04 10:14:17.249	S13	CONFIRMED	0fd34dfa-b206-411c-b18f-55d760883286	f	
2349d1ca-5960-4707-933e-67d13701fca6	57f2b101-ffb6-4649-a03a-74e73e1cf855	Mohamed Moustafa	784200154755514	544032714	mohamedelzyat119@gmail.com	Miss J Cafe\t	f		2025-06-26 06:02:38.798	2025-06-26 06:02:38.798	S2	CONFIRMED	06b13d60-5b5d-4ed9-a1ea-d85b660c59a7	f	
0555c537-59f8-446e-b848-fdecd93f2d9e	57f2b101-ffb6-4649-a03a-74e73e1cf855	Sahar Abdelfattah 	784198857633436	568612258	salmagebali@gmail.com	Deep Café & Roastery \t	f		2025-06-26 06:02:38.798	2025-06-26 06:02:38.798	S3	CONFIRMED	c26ef452-94c1-431b-a01b-a1ebd296bc84	f	
6fc83e5f-0e5e-4c95-b5ae-78aee0d9b6b8	57f2b101-ffb6-4649-a03a-74e73e1cf855	Rasha Adam Hamad	784198633350800	582241778	rshabakri538@gmail.com	Jory catering Service\t	f		2025-06-26 06:02:38.798	2025-06-26 06:02:38.798	S4	CONFIRMED	ee87e1bc-8c22-4f2a-a24c-e4cb208ff72e	f	
97a65376-c8ba-4013-b7f5-e57cc4830d38	57f2b101-ffb6-4649-a03a-74e73e1cf855	Tarek Mohammad 	784200366834248	562531567	tarizkanakri68@gmail.com	Al Sultan Markets & Bakeries\t	f		2025-06-26 06:02:38.798	2025-06-26 06:02:38.798	S5	CONFIRMED	a53745a4-0b93-44da-a3f9-e85205fb7cdf	f	
3659414d-572f-410c-b9f2-ab6b93873463	57f2b101-ffb6-4649-a03a-74e73e1cf855	Ali Mohamad 	784199761964602	566525605	ali.aldali2021@gmail.com	Al Sultan Markets & Bakeries\t	f		2025-06-26 06:02:38.798	2025-06-26 06:02:38.798	S6	CONFIRMED	127c4da4-c11a-4501-ad54-08e6a221ab0a	f	
0241b2e3-2fae-4dac-883a-2e6452cee221	d3461489-a74d-441b-87d5-d8155fc06768					Margin Café	f		2025-07-04 10:14:17.249	2025-07-04 10:14:17.249	S14	CONFIRMED	b6af8f5e-6026-4ddf-9801-5cee82e5fc44	f	
0f8d930a-c80a-4229-909a-8aea372d0ba8	d3461489-a74d-441b-87d5-d8155fc06768			0506905404		Margin Café	f		2025-07-04 10:14:17.249	2025-07-04 10:14:17.249	S15	CONFIRMED	b07652af-fbff-4a9e-9b10-46bb111ae6bf	f	
215abe40-25fa-4b8a-a265-c09cf30ec1e2	15fa42ed-798b-4fdb-98d1-016025c33e70					Bangla Baraka Restaurant 	f		2025-07-05 11:08:38.456	2025-07-05 11:08:38.456	S1	CONFIRMED	e6e1af81-4de0-423e-bba2-dbaeedb31dad	f	
119703cf-d565-484a-bbeb-cb972d53d33f	15fa42ed-798b-4fdb-98d1-016025c33e70					Al Sadu Mandi Restaurant	f		2025-07-05 11:08:38.456	2025-07-05 11:08:38.456	S2	CONFIRMED	789c7c64-acae-4f2b-a7be-e42deae1551c	f	
0d79a5a9-b618-4c35-8f66-b9b323ac7509	57f2b101-ffb6-4649-a03a-74e73e1cf855	Ibrahim Elsayed 	784200352540007	543376793	ebrahimsakr262@gmail.com	Al Sultan Markets & Bakeries\t	f		2025-06-26 06:02:38.798	2025-06-26 06:02:38.798	S7	CONFIRMED	49213d11-e1b2-4d9e-9e98-57f92850900f	f	
767461ce-d5a7-4784-9c36-3cad14087ca7	57f2b101-ffb6-4649-a03a-74e73e1cf855	Alaa Aldin Ali	784198465258501	554192998	joo.waw@gmail.com	Al Sultan Markets & Bakeries\t	f		2025-06-26 06:02:38.798	2025-06-26 06:02:38.798	S8	CONFIRMED	57e8241f-cf1d-411a-95ab-168b2163cc4c	f	
8ec32c78-c5bc-4a07-945a-1e0018e78b24	57f2b101-ffb6-4649-a03a-74e73e1cf855	Khaled  Ahmed	784200411876582	551756558	khaled456@gmail.com	Al Sultan Markets & Bakeries\t	f		2025-06-26 06:02:38.798	2025-06-26 06:02:38.798	S9	CONFIRMED	43d8ca4b-5c09-4ffb-82ff-7a69fa5d45c3	f	
d16aec08-d005-43bd-93dd-a0f44f066486	57f2b101-ffb6-4649-a03a-74e73e1cf855	Moussa Meshref 	784198413691969	545008684	mousameshref7@gmail.com	Al Sultan Markets & Bakeries\t	f		2025-06-26 06:02:38.798	2025-06-26 06:02:38.798	S10	CONFIRMED	c9f697ce-c8b4-4825-b4ee-4cb07f9ac14c	f	
047c537a-165b-4539-9c14-425f97283d13	57f2b101-ffb6-4649-a03a-74e73e1cf855	Moustafa Fawzi Ali	784200094707708	543353683	fwzymstfy530@gmail.com	Doner Almani Cafeteria\t	f		2025-06-26 06:02:38.798	2025-06-26 06:02:38.798	S11	CONFIRMED	02f8ff7a-7cb0-4dce-bc43-cee24ad8ea0c	f	
d781eff4-0554-4c93-8967-26cd55d54b6e	57f2b101-ffb6-4649-a03a-74e73e1cf855	Ahmad Mohammad 	784198797427295	554276661	aazz12345aazz44@gmail.com	Pizza World \t	f		2025-06-26 06:02:38.798	2025-06-26 06:02:38.798	S12	CONFIRMED	9f52845d-52bf-42f4-9d6b-b28d97c96560	f	
f948e3a7-3909-401e-ba1a-27600ec4265d	57f2b101-ffb6-4649-a03a-74e73e1cf855	Yasin Mahmoud	784200068265816	569447133	eyas60402@gmail.com	30 Fruit Juice and Pastries café \t	f		2025-06-26 06:02:38.798	2025-06-26 06:02:38.798	S13	CONFIRMED	3f2bef6c-537c-47ba-b145-ff9423d7e933	f	
9f73364b-8cac-44ff-8276-ff9bed4e016f	57f2b101-ffb6-4649-a03a-74e73e1cf855	Yahya Mohiy 	784200346026873	552277195	yehya.qador@gmail.com	Grandiose Supermarket\t	f		2025-06-26 06:02:38.798	2025-06-26 06:02:38.798	S15	CONFIRMED	31fcb934-5efd-45c6-ab3b-8806d68fc5c5	f	
5682f3bc-e2d1-44ee-ac60-db208fed2756	7003baa5-f4fd-4046-8616-c262bb72f1c6	Cherish Bulan 	784198946287194	544255036	hrprocess@iml-es.com	Self -IML	f		2025-07-05 06:41:03.469	2025-07-05 06:41:03.469	S2	CONFIRMED	8816df08-b391-4282-ad78-74baeee9aba4	f	
7f94808d-95a1-4093-83bf-666bd25321d0	7003baa5-f4fd-4046-8616-c262bb72f1c6	Nomer Turado	784198578713574	567533714	nomeralvaro@gmail.com	Feathers Cafe 	f		2025-07-05 06:41:03.469	2025-07-05 06:41:03.469	S14	CONFIRMED	ab06378f-5fd3-4ada-9666-67c470194d5b	f	
f84c0299-183e-4797-80fe-9d5542d9a13e	15fa42ed-798b-4fdb-98d1-016025c33e70					Hinoki Restaurant	f		2025-07-05 11:08:38.456	2025-07-05 11:08:38.456	S3	CONFIRMED	97f2b48c-1214-4726-8866-b5016daa3b38	f	
67836f5f-637f-45a7-b1db-396c6cb8dc8b	15fa42ed-798b-4fdb-98d1-016025c33e70					Hinoki Restaurant	f		2025-07-05 11:08:38.456	2025-07-05 11:08:38.456	S4	CONFIRMED	536aacf3-a7f6-42ee-b77b-352d0b9cf1ed	f	
259b738d-fa24-47a6-814e-0fb5667194a4	15fa42ed-798b-4fdb-98d1-016025c33e70					Al Remal Thahabeya Restaurant\t	f		2025-07-05 11:08:38.456	2025-07-05 11:08:38.456	S5	CONFIRMED	dc5e39cb-9e84-41e9-8545-65249c1f8766	f	
32b9e399-d162-4f70-84ba-e14461b09929	15fa42ed-798b-4fdb-98d1-016025c33e70					Crystal Diamond Restaurant\t	f		2025-07-05 11:08:38.456	2025-07-05 11:08:38.456	S6	CONFIRMED	9e5e34cd-004c-4784-9419-2cff9a66abd4	f	
adc26fca-df26-428c-aef7-9ffb5bc116d6	15fa42ed-798b-4fdb-98d1-016025c33e70					Al Mallah Restaurant & Grills	f		2025-07-05 11:08:38.456	2025-07-05 11:08:38.456	S9	CONFIRMED	4a47204c-423f-4255-a7ca-603f0f1f6c37	f	
faf3e1b5-924f-471b-8e00-fbb700fc30dd	15fa42ed-798b-4fdb-98d1-016025c33e70					Delice Boutique	f		2025-07-05 11:08:38.456	2025-07-05 11:08:38.456	S10	CONFIRMED	bcf24ecc-c283-44ed-a57e-3a84bb84c1cb	f	
d095b88d-555f-49b7-bae2-29336609d5c6	de66059e-7f74-4cee-87ba-5f2ef1d4cd4b	Sabibur Rahman Abbas Ali 	784200385591597	0555860171	sabiburrahman86@gmail.com	Golden Kattans Restaurant 	f		2025-07-05 09:48:36.585	2025-07-05 09:48:36.585	S1	CONFIRMED	fc6d566c-54f7-442f-9c20-79d5e04bd250	f	
eaf62d74-f278-47b3-8de6-3e5a611d1c2e	de66059e-7f74-4cee-87ba-5f2ef1d4cd4b	Mahabu Alam Mojaher Miah	784197139092940	0509846482	mahabua3053@gmail.com	Princey Cafe 	f		2025-07-05 09:48:36.585	2025-07-05 09:48:36.585	S2	CONFIRMED	de184760-ea6d-4995-99f5-98a1b5cca4fb	f	
1fc2e87b-a4e6-4a5c-94b5-569ae705ee45	de66059e-7f74-4cee-87ba-5f2ef1d4cd4b	Mahfuzul Alam Nurul Alam 	784198427519842	0504752128		Ahmed Ali Refreshment	f		2025-07-05 09:48:36.585	2025-07-05 09:48:36.585	S3	CONFIRMED	86b6a925-2ecc-4a49-8be5-b67941a6fc20	f	
249b4517-02fe-4651-96d5-99667f6da3ba	de66059e-7f74-4cee-87ba-5f2ef1d4cd4b	Hidhayathullah Koduvali Aboobacker 	784198879581316	0508404157	mahutn2@gmail.com	Tea Breeze Cafeteria 	f		2025-07-05 09:48:36.585	2025-07-05 09:48:36.585	S4	CONFIRMED	167789e7-59dd-4908-a9d4-170295123e73	f	
f946039a-696b-48b5-874a-ac2c68fd224d	15fa42ed-798b-4fdb-98d1-016025c33e70			0566178772		Harees Alfareej Restaurant \t	f		2025-07-05 11:08:38.456	2025-07-05 11:08:38.456	S11	CONFIRMED	1b7aa4ad-296d-48dd-a0fd-4ff2c8f7836c	f	
bb1eaae3-3b40-4bbd-990d-c7e3cdbbcc81	75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	Ramila Pandey	784200211671167	502759483	khadkaariya23@gmail.com	McDonalds	t		2025-06-26 12:01:26.497	2025-06-26 12:01:26.497	S1	CONFIRMED	83142ff6-35cd-43f0-a379-d927c21ddc6d	f	
f60f3f49-7117-4842-9454-ceee323e4897	75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	Susmita Tamang	784200114639022	506372565	tamangsusmita186@gmail.com		t		2025-06-26 12:01:26.497	2025-06-26 12:01:26.497	S2	CONFIRMED	10ef1c49-96fd-4fc4-b613-4adde6852d37	f	
9f564a6e-e21b-4822-b2c9-9ce6d2dd025a	75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	Amar Sunar	784199824754271	0502378025	thapalalu42@gmail.com	McDonald's	t		2025-06-26 12:01:26.497	2025-06-26 12:01:26.497	S3	CONFIRMED	6771b816-9fb2-4fb3-8243-24982ec89d6e	f	
f6f2dc30-ac25-4618-a6d4-2a504f4ec6d6	75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	Nhima Tamang	784199616917235	509261554	moktannhima@gmail.com	McDonald's	t		2025-06-26 12:01:26.497	2025-06-26 12:01:26.497	S4	CONFIRMED	0ee70eef-ae92-461a-ad11-5396c6457945	f	
3c69d4b3-fa56-4ef2-b837-9627a260f000	15fa42ed-798b-4fdb-98d1-016025c33e70					Mulhem Café and Specialty Coffee and Tea\t	f		2025-07-05 11:08:38.456	2025-07-05 11:08:38.456	S14	CONFIRMED	151f180a-1be9-4087-9da5-9289942ed44f	f	
cf230735-1550-4c30-aaed-d585e7b8d834	59c3331b-5cad-4236-a72e-1a3b6547128f	Jijin Murikkankattil Chandran 	784199651816896	0528017166	babujijin255@gmail.com	Abu saood Trading Establishment	f		2025-07-01 08:17:46.232	2025-07-01 08:17:46.232	S3	CONFIRMED	e6db72ec-0792-4be8-a083-5e4e4b4c6512	f	
43e1edc1-0544-4bec-a06f-4ff80dda56df	59c3331b-5cad-4236-a72e-1a3b6547128f	Mohammed Aslam Maambatt	784200162834061	0545688940	ma8298495@gmail.com	Abu saood Trading Establishment	f		2025-07-01 08:17:46.232	2025-07-01 08:17:46.232	S4	CONFIRMED	20ab3e98-8a27-4f13-98e4-a528c9230e51	f	
c6258252-e380-4cd2-b0c5-8a37a872d211	59c3331b-5cad-4236-a72e-1a3b6547128f	Noushad Thayyil Saidalavi	784199124605959	0568517369	noushadtheyyil@gmail.com	Abu saood Trading Establishment	f		2025-07-01 08:17:46.232	2025-07-01 08:17:46.232	S5	CONFIRMED	d40180da-cf40-4cf9-9ac8-934e75173b64	f	
580b3a5c-cd34-460b-99f7-0211ace40d59	34d730a8-3aab-4892-92d1-e5cc3b928aae	Kritika Pandit		508629376	kritikac872@gmail.com	Mcdonald's	f		2025-07-05 07:04:22.33	2025-07-05 07:04:22.33	S1	NOT_CONFIRMED	0f168c8c-f2f3-426f-b793-9f2a95a29768	f	
423f09b2-bbd2-457d-bb4c-4eac89bbaa98	e38fa1a5-1232-4b9d-bcbc-3f858b4e5a17					Grand mart	f		2025-07-04 10:15:05.576	2025-07-04 10:15:05.576	S1	NOT_CONFIRMED	2a20e14f-9b1c-46a5-8732-585562e37f2f	f	
228f6b6d-aba2-4c45-a9dc-026f998c4394	1c36399f-ffcb-4b3d-8f2c-34fa94bf7700	Gnana Krishna Bindla	784199790699005	0502416679	gnanaakon@gmail.com	Pearl Rotana 	f		2025-06-30 09:05:02.185	2025-06-30 09:05:02.185	S2	CONFIRMED	606702a7-44e0-4bfc-8789-ccf27f67e733	f	
57529195-998d-4ffa-90ba-97a838185483	1c36399f-ffcb-4b3d-8f2c-34fa94bf7700	Rajeev Kumar Ramachandran	784198998152536	0566946383	kottummel89@gmail.com	Centro Al Manhal Hotel 	f		2025-06-30 09:05:02.185	2025-06-30 09:05:02.185	S3	CONFIRMED	4f45e384-51b9-412a-a134-4cf0055373d0	f	
d4a1f3d5-1094-463d-a352-5083c7f80372	1c36399f-ffcb-4b3d-8f2c-34fa94bf7700	Ansar Amedul 	784199336396157	0544656798	ansar0405@gmail.com	Pearl Rotana 	f		2025-06-30 09:05:02.185	2025-06-30 09:05:02.185	S4	CONFIRMED	4f2cf3e3-68d4-44fb-98c9-c0cc21c0ff89	f	
30863bba-d66b-456b-b16f-ff044d87e7c0	1c36399f-ffcb-4b3d-8f2c-34fa94bf7700	Elisha Anzel De Guia Gonzales 	784200426864672	0503079436	elishagonzales123@gmail.com	Pearl Rotana 	f		2025-06-30 09:05:02.185	2025-06-30 09:05:02.185	S5	CONFIRMED	c23a1410-8985-4bd0-90db-76904546b67a	f	
329b16c7-594f-42ea-8d36-c89d4eae2172	1c36399f-ffcb-4b3d-8f2c-34fa94bf7700	Rhea Jean Baaluro Vios 	784199083859258	0561922465	xaga08@gmail.com	Blossom Hotpot Restaurant 	f		2025-06-30 09:05:02.185	2025-06-30 09:05:02.185	S6	CONFIRMED	4d4e9b46-1adf-48b9-b86e-10877c3c8022	f	
fc1e9611-1c58-4353-b91e-4f0557a7409a	1c36399f-ffcb-4b3d-8f2c-34fa94bf7700	Jagath Chandana Opatha Vidana Pathiranage	784198902584162	0561130531	Jagathchandan1@gmail.cm	Centro Hotel Al Manhal 	f		2025-06-30 09:05:02.185	2025-06-30 09:05:02.185	S8	CONFIRMED	d65af68f-e91c-4abb-942a-7deed027d333	f	
1c76a64d-3a1c-48c2-8ed5-d1d990688ab9	1c36399f-ffcb-4b3d-8f2c-34fa94bf7700	Khant Zaw	784200373498565	0569722989	khantzawoo2003@gmail.com	Khalidiya Palace Rayhaan	f		2025-06-30 09:05:02.185	2025-06-30 09:05:02.185	S9	CONFIRMED	4d368bb3-e47c-412f-8d51-c5fe7a1b8dec	f	
a2600f75-7a8c-4724-9801-17e3eac64323	1c36399f-ffcb-4b3d-8f2c-34fa94bf7700	Santhosh Sundaran Pillai	784198109680714	0566946610	winspallai@gmail.com	Pearl Rotana 	f		2025-06-30 09:05:02.185	2025-06-30 09:05:02.185	S10	CONFIRMED	ea352736-07b6-4c1b-ba01-8183f9e57ee4	f	
028cf438-2c8f-483d-8ca8-2e4fd802d31b	1c36399f-ffcb-4b3d-8f2c-34fa94bf7700	Sheraz Behadar Ghulam  Qadar	784197903736532	0508617120	sherazthandkiwal@gmail.com	Novotel	f		2025-06-30 09:05:02.185	2025-06-30 09:05:02.185	S11	CONFIRMED	4e0e0eea-5885-4919-ae57-b36c9e6223a4	f	
18e54820-6568-45df-80ce-9154629ad079	1c36399f-ffcb-4b3d-8f2c-34fa94bf7700	Sherina Nansubuga 	784200086168786	0522675473	kassylavslav5@gmail.com	Bedashing Beauty Lounge	f		2025-06-30 09:05:02.185	2025-06-30 09:05:02.185	S12	CONFIRMED	c585641e-c896-45a5-942c-9f368be8cd13	f	
2ebe48d5-29b8-49df-a04d-efe994a531d3	e38fa1a5-1232-4b9d-bcbc-3f858b4e5a17					Grand mart	f		2025-07-04 10:15:05.576	2025-07-04 10:15:05.576	S2	NOT_CONFIRMED	f977eec9-8a04-42c5-9d0c-c81fd19babfd	f	
f17e4845-fec1-4bfa-82ca-dcfefd244800	e38fa1a5-1232-4b9d-bcbc-3f858b4e5a17	Grand mart				Grand mart	f		2025-07-04 10:15:05.576	2025-07-04 10:15:05.576	S3	NOT_CONFIRMED	6c6dfe37-ebff-48b0-8302-2df13ed09f1a	f	
9dc72172-9f81-498e-85e4-b152a2fe454c	e38fa1a5-1232-4b9d-bcbc-3f858b4e5a17	Grand mart				Grand mart	f		2025-07-04 10:15:05.576	2025-07-04 10:15:05.576	S4	NOT_CONFIRMED	d1e432ba-bf0b-4439-b548-d7c9e2ce8cf1	f	
06702c8b-2245-471c-8991-075581694056	e38fa1a5-1232-4b9d-bcbc-3f858b4e5a17					Harees restaurant	f		2025-07-04 10:15:05.576	2025-07-04 10:15:05.576	S5	NOT_CONFIRMED	6328132f-5798-4423-b9fe-6f437e2cb327	f	
07a508e3-b77b-42bf-9565-efc07c78b001	e38fa1a5-1232-4b9d-bcbc-3f858b4e5a17			0566178772		Harees restaurant	f		2025-07-04 10:15:05.576	2025-07-04 10:15:05.576	S6	NOT_CONFIRMED	7c5f311f-ecad-46b4-a879-7c7e6327bc41	f	
a7dedfc6-cc8f-4a10-9890-bca772b4a9f6	e38fa1a5-1232-4b9d-bcbc-3f858b4e5a17					Cro Bakery and Cafe	f		2025-07-04 10:15:05.576	2025-07-04 10:15:05.576	S7	NOT_CONFIRMED	e9c478a6-95a1-4545-8b95-09d553c9240f	f	
9153227c-fc65-447c-8783-e29fc308cfc0	e38fa1a5-1232-4b9d-bcbc-3f858b4e5a17					Cro Bakery and Cafe	f		2025-07-04 10:15:05.576	2025-07-04 10:15:05.576	S8	NOT_CONFIRMED	222a312d-6e8c-41d1-b6a0-86384f8c97a7	f	
cf673b15-919c-4f14-9247-f10abf8aef24	e38fa1a5-1232-4b9d-bcbc-3f858b4e5a17					Cro Bakery and Cafe	f		2025-07-04 10:15:05.576	2025-07-04 10:15:05.576	S9	NOT_CONFIRMED	348c346d-79be-407d-ad26-f55c86a63231	f	
3bc2e639-8e1b-4d67-89e8-0bf781b8e3df	e38fa1a5-1232-4b9d-bcbc-3f858b4e5a17	Wood House Restaurant					f		2025-07-04 10:15:05.576	2025-07-04 10:15:05.576	S10	NOT_CONFIRMED	ef689b73-2618-44fa-81c7-149466ca5030	f	
b33c008b-ed8b-49ef-ab33-cd1a0c3b2423	e38fa1a5-1232-4b9d-bcbc-3f858b4e5a17					Wood House Restaurant	f		2025-07-04 10:15:05.576	2025-07-04 10:15:05.576	S11	NOT_CONFIRMED	1e3ca798-5b1d-4358-8081-9466bb4cda4d	f	
c7c4e741-f60e-4526-82cd-4fe100385f1f	e38fa1a5-1232-4b9d-bcbc-3f858b4e5a17					Cro Bakery and Cafe	f		2025-07-04 10:15:05.576	2025-07-04 10:15:05.576	S12	NOT_CONFIRMED	25b4fb27-f06d-402c-8c17-cbff0c137efc	f	
8f3a808d-15d1-4627-9e6e-b1b545139bbf	e38fa1a5-1232-4b9d-bcbc-3f858b4e5a17					Cro Bakery and Cafe	f		2025-07-04 10:15:05.576	2025-07-04 10:15:05.576	S13	NOT_CONFIRMED	2f57b090-f51b-4da2-9547-f74b6a8c8b45	f	
2d06a206-02c8-488a-a4ff-5a09045a5dbe	e38fa1a5-1232-4b9d-bcbc-3f858b4e5a17			0558637577		Al Noor Modern Bakery	f		2025-07-04 10:15:05.576	2025-07-04 10:15:05.576	S14	NOT_CONFIRMED	1823dc9a-c4ab-4e30-bbdd-72cdba02fe29	f	
72fe2721-8877-4a8a-b967-51176023ae86	34d730a8-3aab-4892-92d1-e5cc3b928aae	Sagun Pariyar 		502768460	sagunpariyar229@gmail.com	Mcdonald's	f		2025-07-05 07:04:22.33	2025-07-05 07:04:22.33	S2	NOT_CONFIRMED	120f674f-7c25-4944-8ad9-cb68e9147129	f	
5f3ec183-0866-42e3-b1af-156abc55fc78	b5bf9c33-d1b6-4519-8ca5-f91c3822d575					Al Anqaa Grocery Shop \t	f		2025-07-04 12:15:15.266	2025-07-04 12:15:15.266	S1	CONFIRMED	3cce8065-dd7b-4bb5-a74f-93c2cfdcaa87	f	
65d903dc-6035-4694-b58e-9d447c184196	34d730a8-3aab-4892-92d1-e5cc3b928aae	Ali Javed		508436397	marli9257@gmail.com	McDonald's	t		2025-07-05 07:04:22.33	2025-07-05 07:04:22.33	S3	NOT_CONFIRMED	992373a3-03d2-4472-bb99-ee4a8348c872	f	
eb920690-f58a-49e0-951a-9ddbe422bfc3	34d730a8-3aab-4892-92d1-e5cc3b928aae	Dolmo Lo		558628173	rasmilalo553@gmail.com	McDonald's	t		2025-07-05 07:04:22.33	2025-07-05 07:04:22.33	S4	NOT_CONFIRMED	aa54db9c-fe19-44a5-a756-9920f2eb198b	f	
9f0b671a-8a55-4cd8-ad63-9696037f17f2	34d730a8-3aab-4892-92d1-e5cc3b928aae	Sathya Vithakshani P. G. Gamaralalage		0555390167	vithakshanis@gmail.com	McDonald's	t		2025-07-05 07:04:22.33	2025-07-05 07:04:22.33	S5	NOT_CONFIRMED	1ead9faa-33d2-49b7-926b-d07a9651102b	f	
d54ddcfb-509a-4297-87b1-5e2a7d44d086	d13d98b1-3085-45b2-ba73-475e65821c91	Issa Abdullah Abdulkarim	784200654879103			Al Bait Al Soury Restaurant & Roster	t		2025-06-30 08:30:01.326	2025-06-30 08:30:01.326	S1	CONFIRMED	9ae81e0c-5926-4453-b98f-75c4e81c9dd8	f	
9fdb204c-0c33-4ac2-a8d1-0f3912a582fb	d13d98b1-3085-45b2-ba73-475e65821c91	Hosin Abdul Hamid Altayar				Al Bait Al Soury Restaurant & Roster	t		2025-06-30 08:30:01.326	2025-06-30 08:30:01.326	S2	CONFIRMED	4d03b881-77af-4ee1-aeed-ef04f2dc0647	f	
7328e6a2-11ee-43ec-a554-c0ed75026bf6	d13d98b1-3085-45b2-ba73-475e65821c91	Mohammad Mahrous Fardous Alhalabia				Al Bait Al Soury Restaurant & Roster	t		2025-06-30 08:30:01.326	2025-06-30 08:30:01.326	S3	CONFIRMED	4d03b881-77af-4ee1-aeed-ef04f2dc0647	f	
236403ea-5aec-4130-8176-50e53667579b	d13d98b1-3085-45b2-ba73-475e65821c91	Mohamed Nouri Mamoun Shakfa	784200099039594			Al Bait Al Soury Restaurant & Roster	t		2025-06-30 08:30:01.326	2025-06-30 08:30:01.326	S4	CONFIRMED	4d03b881-77af-4ee1-aeed-ef04f2dc0647	f	
7db74ef9-79f0-4724-b4b2-237fc3b1e50d	d13d98b1-3085-45b2-ba73-475e65821c91	Ramez Mazhar Assani	784200052216809			Al Bait Al Soury Restaurant & Roster	t		2025-06-30 08:30:01.326	2025-06-30 08:30:01.326	S5	CONFIRMED	4d03b881-77af-4ee1-aeed-ef04f2dc0647	f	
519b17a0-3bb8-4c9e-b434-bd89125e4036	d13d98b1-3085-45b2-ba73-475e65821c91	Hassan Kassem Al Haj Ali	784200250831128			Al Bait Al Soury Restaurant & Roster	t		2025-06-30 08:30:01.326	2025-06-30 08:30:01.326	S6	CONFIRMED	4d03b881-77af-4ee1-aeed-ef04f2dc0647	f	
6928d02c-12b5-4a45-9f35-64ccb4e0ce64	d13d98b1-3085-45b2-ba73-475e65821c91	Ahmad Najib Almahameed	784200055396277			Al Bait Al Soury Restaurant & Roster	t		2025-06-30 08:30:01.326	2025-06-30 08:30:01.326	S7	CONFIRMED	4d03b881-77af-4ee1-aeed-ef04f2dc0647	f	
74ef2a54-8385-4e2c-a19a-e6c729272eaf	1c36399f-ffcb-4b3d-8f2c-34fa94bf7700	Dibyani Thapa Magar 	784200152359731	0547547415	dibyanimgr123@gmail.com	Bedashing Beauty Lounge	f		2025-06-30 09:05:02.185	2025-06-30 09:05:02.185	S14	CONFIRMED	ba4935d6-11b0-48b5-9aab-b32946c8183d	f	
8eec46a4-5889-4ab9-84c1-635fab6c4555	1c36399f-ffcb-4b3d-8f2c-34fa94bf7700	Susan Karki 	784199914569902	0563079230	karkisusan63@gmail.com	Bedashing Beauty Lounge	f		2025-06-30 09:05:02.185	2025-06-30 09:05:02.185	S15	CONFIRMED	544c26a1-3828-4327-b2d5-3f07319cddf9	f	
3c86b201-4da3-4574-b02b-df200787c8ad	1c36399f-ffcb-4b3d-8f2c-34fa94bf7700	Novelito  Laciste Salvador 	784197224379533	0561963671	salvadornovelito28@gmail.com	Blossom Hotpot Restaurant	f		2025-06-30 09:05:02.185	2025-06-30 09:05:02.185	S7	CONFIRMED	b93a0530-99a7-4d6f-a3a1-1496c8f00bad	f	
7e4e11d5-ca9a-4627-ac9e-bee54fe9662a	1c36399f-ffcb-4b3d-8f2c-34fa94bf7700	Gerald Aliganira	784199340140351	0552895766	geraldaliganira@gmail.com	Al Rawda Arjaan Hotel 	f		2025-06-30 09:05:02.185	2025-06-30 09:05:02.185	S1	CONFIRMED	f7b5c6b2-3208-4033-a31e-41d291988367	f	
33d8c9c1-87e1-47f3-af24-54df79ab7be2	15fa42ed-798b-4fdb-98d1-016025c33e70					Mulhem Café and Specialty Coffee and Tea\t	f		2025-07-05 11:08:38.456	2025-07-05 11:08:38.456	S15	CONFIRMED	28fe9df0-54bb-429d-95c3-b6485001edfb	f	
188d7ddc-5cf7-47a4-be79-57635bb46916	149fd6d6-467d-468e-a13c-b2a291200b40	Jaseen Ullah				Al Khayyat Investment (AKI)	t		2025-07-02 05:06:54.293	2025-07-02 05:06:54.293	S1	CONFIRMED	8037b4e1-2f52-4140-8ec2-5be3641d2470	f	
579d4fbc-f589-4c9d-ab82-581a797138b2	8d1824c5-41ae-4261-a9e5-46cd3d6f1913	Anisha Rasaili 	784200239803206	0527713352		Dar Karak & Muhala Restaurant 	f		2025-06-30 11:08:02.052	2025-06-30 11:08:02.052	S1	CONFIRMED	a7a5d5ec-c70f-4620-82cc-cfd7e1c10b6b	f	
31a59b98-a8fc-4cd0-84d3-2baebb7da842	8d1824c5-41ae-4261-a9e5-46cd3d6f1913	Shahid Umar 	784200567749658	0522199397	shaheedkhannn12345@gmail.com	Gulf Queen Bakery 	f		2025-06-30 11:08:02.052	2025-06-30 11:08:02.052	S2	CONFIRMED	64cc6491-5db4-49a3-bcea-a27c1276c21d	f	
4407f880-8c01-4ad2-8943-0231f67a809a	8d1824c5-41ae-4261-a9e5-46cd3d6f1913	Sujan Sunar Man Bahadur 	784200250503131	0569188134	Sujan105sunar@gmail.com	Grandmas Grill and Biryani Restaurant 	f		2025-06-30 11:08:02.052	2025-06-30 11:08:02.052	S3	CONFIRMED	5f433ee5-dae0-46c1-a018-9fd068b13c53	f	
9e566924-8487-4a7f-89a8-98b7687a07fd	8d1824c5-41ae-4261-a9e5-46cd3d6f1913	Lalit Kumar Bishwkarma	784199098426796	0524656473	Lalitbahadursoni@gmail.com	Grandmas Grill and Biryani Restaurant	f		2025-06-30 11:08:02.052	2025-06-30 11:08:02.052	S4	CONFIRMED	c0ff897d-3ae6-4b4d-b7f6-717f1a732fec	f	
fcef4fd6-b3a2-4d27-89d3-cf8606e834ad	8d1824c5-41ae-4261-a9e5-46cd3d6f1913	Ravendar Bisht Pushkar 	784200039003536	0502847986	ravindrabisht109@gmail.com	Grandmas Secret  Restaurant 	f		2025-06-30 11:08:02.052	2025-06-30 11:08:02.052	S6	CONFIRMED	a1e450dc-51c5-4a90-8894-7fdcdd2543a4	f	
f31f3101-ff5b-4865-bfbe-fdfecd8fd96d	8d1824c5-41ae-4261-a9e5-46cd3d6f1913	Harendra Singh 	784200071025322	559356838	harendrab737@gmail.com	Grandmas Grill and Biryani Restaurant	f		2025-06-30 11:08:02.052	2025-06-30 11:08:02.052	S8	CONFIRMED	5d4e709d-2b4b-4bdc-84b1-e205474cfe97	f	
af4a6404-678e-4e8f-8b85-5265fd1c6bae	149fd6d6-467d-468e-a13c-b2a291200b40	Kushal Mijar				Al Khayyat Investment (AKI)	t		2025-07-02 05:06:54.293	2025-07-02 05:06:54.293	S2	CONFIRMED	8037b4e1-2f52-4140-8ec2-5be3641d2470	f	
bcc64650-02ac-4a80-b1f6-0a6aa9166b1b	149fd6d6-467d-468e-a13c-b2a291200b40	Mahesh Tamang 				Al Khayyat Investment (AKI)	f		2025-07-02 05:06:54.293	2025-07-02 05:06:54.293	S3	CONFIRMED	8037b4e1-2f52-4140-8ec2-5be3641d2470	f	
0e23f428-6151-4117-a524-57572e27411e	149fd6d6-467d-468e-a13c-b2a291200b40	Arjun Bishwakarm				Al Khayyat Investment (AKI)	t		2025-07-02 05:06:54.293	2025-07-02 05:06:54.293	S4	CONFIRMED	8037b4e1-2f52-4140-8ec2-5be3641d2470	f	
8398de61-2eb7-4872-81d0-1a4343461a23	149fd6d6-467d-468e-a13c-b2a291200b40	Roshan Khatiwada				Al Khayyat Investment (AKI)	t		2025-07-02 05:06:54.293	2025-07-02 05:06:54.293	S5	CONFIRMED	8037b4e1-2f52-4140-8ec2-5be3641d2470	f	
4c0ecf46-418f-4a3f-b61e-7bd27cfe5bf7	149fd6d6-467d-468e-a13c-b2a291200b40	Rakesh Negulapu				Al Khayyat Investment (AKI)	t		2025-07-02 05:06:54.293	2025-07-02 05:06:54.293	S6	CONFIRMED	8037b4e1-2f52-4140-8ec2-5be3641d2470	f	
cec735e7-02b0-416c-9ae3-c3bc6d4f6afc	149fd6d6-467d-468e-a13c-b2a291200b40	Ramesh Kumar Mandal				Al Khayyat Investment (AKI)	t		2025-07-02 05:06:54.293	2025-07-02 05:06:54.293	S7	CONFIRMED	8037b4e1-2f52-4140-8ec2-5be3641d2470	f	
c171dcc1-e51a-4828-8ad0-22f0703e7d35	149fd6d6-467d-468e-a13c-b2a291200b40	Muhammad Zahoor 				Al Khayyat Investment (AKI)	t		2025-07-02 05:06:54.293	2025-07-02 05:06:54.293	S8	CONFIRMED	8037b4e1-2f52-4140-8ec2-5be3641d2470	f	
a89afc29-e2b8-4137-ad58-7688de119f5d	149fd6d6-467d-468e-a13c-b2a291200b40	Ashal Rana Magar				Al Khayyat Investment (AKI)	t		2025-07-02 05:06:54.293	2025-07-02 05:06:54.293	S9	CONFIRMED	8037b4e1-2f52-4140-8ec2-5be3641d2470	f	
3f06a4b0-8b63-484e-83a7-6ef6ba18a9a5	149fd6d6-467d-468e-a13c-b2a291200b40	Jitan Bhandari				Al Khayyat Investment (AKI)	t		2025-07-02 05:06:54.293	2025-07-02 05:06:54.293	S10	CONFIRMED	8037b4e1-2f52-4140-8ec2-5be3641d2470	f	
23f0444c-43eb-4b63-a562-a34b44915b75	149fd6d6-467d-468e-a13c-b2a291200b40	Lokendra Giri				Al Khayyat Investment (AKI)	t		2025-07-02 05:06:54.293	2025-07-02 05:06:54.293	S11	CONFIRMED	8037b4e1-2f52-4140-8ec2-5be3641d2470	f	
3cb11e7c-1d0a-4976-85e7-2831e2be8446	149fd6d6-467d-468e-a13c-b2a291200b40	Shiva Kumar				Al Khayyat Investment (AKI)	t		2025-07-02 05:06:54.293	2025-07-02 05:06:54.293	S12	CONFIRMED	8037b4e1-2f52-4140-8ec2-5be3641d2470	f	
31ad8245-9fb0-4042-aa79-da483591d665	15fa42ed-798b-4fdb-98d1-016025c33e70					Rebel Food  Restaurant	f		2025-07-05 11:08:38.456	2025-07-05 11:08:38.456	S8	CONFIRMED	122edd0b-d9f9-4f6c-9ba5-b5fac2d8214d	f	
e2f55c06-87d8-4c3c-9f2e-0972a6a9ebb1	59c3331b-5cad-4236-a72e-1a3b6547128f	Shabeeb Abdul Karim Poyakkara	784199475709509	0527686949	shabbauae@gmail.com	Air Fresh Baqala 	f		2025-07-01 08:17:46.232	2025-07-01 08:17:46.232	S6	CONFIRMED	2bfed670-750a-48df-8c71-7264cdb0e2ef	f	
d78c1698-bcac-45d2-a07a-1218a5b5f12a	59c3331b-5cad-4236-a72e-1a3b6547128f	Abdul Salam Manikoth 	784197339329720	0569734041	salammp308@gmail.com	Pinoy Grocery 	f		2025-07-01 08:17:46.232	2025-07-01 08:17:46.232	S7	CONFIRMED	bee5f148-d509-4e0d-89b3-a7a0bc55b20e	f	
af1fc484-0472-4728-8fed-f86d8be2f4a8	59c3331b-5cad-4236-a72e-1a3b6547128f	Irfaz  Mohammed Ajmal Ibrahim  	784199747050799	0562581840	muhammadirfaz940@gmail.com	Air Fresh Baqala 	f		2025-07-01 08:17:46.232	2025-07-01 08:17:46.232	S11	CONFIRMED	68d791a3-dafd-4b0c-90a0-3c5b44c9af93	f	
09c47f85-dca2-4a66-a2f5-6c8f5604c3b2	59c3331b-5cad-4236-a72e-1a3b6547128f	Mohamed Fazil Ali 	784199329536140	0566601008	ckfazilali@gmail.com	Al Rahi Baqala 	f		2025-07-01 08:17:46.232	2025-07-01 08:17:46.232	S12	CONFIRMED	0cd65ff6-7d90-495b-b32a-adb3fabfa41d	f	
ad924597-a20e-4b47-8bd1-7fa86a8d0a45	59c3331b-5cad-4236-a72e-1a3b6547128f	Muhammad Jamal Hamza 	784198854376468	0565895357	muhammadjamal@gmail.com	Al Rahi Baqala 	f		2025-07-01 08:17:46.232	2025-07-01 08:17:46.232	S13	CONFIRMED	133644d3-7789-4a43-869a-dcf83fab1604	f	
b1d776e0-d7b1-48bb-8347-aad00bed270a	59c3331b-5cad-4236-a72e-1a3b6547128f	Muhammed Anas  Thavoor Moideen 	784199739598102	0562007183	anasmame90@gmail.com	Baqala Attraction 	f		2025-07-01 08:17:46.232	2025-07-01 08:17:46.232	S1	CONFIRMED	14be4179-7234-4cfc-bca2-6aba74bc9181	f	
9060ae07-81fe-43f1-9a9a-7446307431a1	59c3331b-5cad-4236-a72e-1a3b6547128f	Shihabudheen Irumbili 	784198079350066	0565437451	shihabe702@gmail.com	Baqala Attraction 	f		2025-07-01 08:17:46.232	2025-07-01 08:17:46.232	S14	CONFIRMED	ee67085b-9e95-4878-adb8-ad832a72e5c4	f	
cf6bc803-5b06-4566-96ec-94615ea0a7a8	59c3331b-5cad-4236-a72e-1a3b6547128f	Muhammad Faisal Moidu	784200444951907	0542526085	fhazfaizal@gmail.com	Baqala Ismail Lari	f		2025-07-01 08:17:46.232	2025-07-01 08:17:46.232	S15	CONFIRMED	01c9e661-29f2-4bf9-ba95-bc564b3de45c	f	
59b0f765-a3d6-4e3b-9486-076dddea4c44	59c3331b-5cad-4236-a72e-1a3b6547128f	Harshad Ethikkat Hussain 	784199932327564	0529573536	hussainharshad369@gmail.com	Abu saood Trading Establishment	f		2025-07-01 08:17:46.232	2025-07-01 08:17:46.232	S2	CONFIRMED	608429cc-49dd-41d8-ae76-d290cba49e1a	f	
06679d56-623c-4966-8e8e-da5828969d9c	15fa42ed-798b-4fdb-98d1-016025c33e70					Rebel Foods Restaurant	f		2025-07-05 11:08:38.456	2025-07-05 11:08:38.456	S7	CONFIRMED	5f9b643f-bac8-4ae9-a848-a0cc398ddfc1	f	
4b52ecf7-51d8-47c7-9b2e-37eec7d88212	a671c2c7-441f-4c67-9514-5f91ec40e6fd					Helal Al ain Cafeteria\t	f		2025-07-04 11:32:23.337	2025-07-04 11:32:23.337	S1	CONFIRMED	91fe1e2c-8ca5-4907-84dd-4076b16c54d8	f	
f3f76161-2d6a-445c-a804-6707e62a48a2	a671c2c7-441f-4c67-9514-5f91ec40e6fd					Helal Al ain Cafeteria\t	f		2025-07-04 11:32:23.337	2025-07-04 11:32:23.337	S2	CONFIRMED	77773ce6-aab4-4ac6-b315-d44ad0676388	f	
0c30c56e-1014-4d40-906a-15ae0d44ed5b	a671c2c7-441f-4c67-9514-5f91ec40e6fd	Rajesh Thuvakkunnan	784196682478738			Café Kudumbasree Restaurant	f		2025-07-04 11:32:23.337	2025-07-04 11:32:23.337	S3	CONFIRMED	5b833d96-204a-4938-a95d-968312941f56	f	
92418bb7-4769-47e1-b790-1f77022d5212	a671c2c7-441f-4c67-9514-5f91ec40e6fd	Ahammed Shafi 	784199496451966			Café Kudumbasree Restaurant	f		2025-07-04 11:32:23.337	2025-07-04 11:32:23.337	S4	CONFIRMED	6ff20996-a5cf-4184-baf4-ef770d5185ef	f	
3956179c-c436-4c76-b945-f0ed6ed0af19	b5bf9c33-d1b6-4519-8ca5-f91c3822d575					AL noorain vef and fruits\t	f		2025-07-04 12:15:15.266	2025-07-04 12:15:15.266	S2	CONFIRMED	51641595-5cf9-4432-a875-aabf9e833aa8	f	
11120ed8-f3a4-4b51-8158-45211621af12	b5bf9c33-d1b6-4519-8ca5-f91c3822d575					Lulu Al Sahra Food Stuff Stores L.L.C	f		2025-07-04 12:15:15.266	2025-07-04 12:15:15.266	S3	CONFIRMED	3bfb1e8f-feb0-4621-b99d-b30435a60f14	f	
440b3a4c-4cc2-41ce-99dc-95d9683440e5	b5bf9c33-d1b6-4519-8ca5-f91c3822d575					baqla	f		2025-07-04 12:15:15.266	2025-07-04 12:15:15.266	S4	CONFIRMED	2cf4cb9c-1dba-4226-b77b-7fe2d0a50fa6	f	
ffc3057e-47d4-4466-a9fe-41beb1960488	a671c2c7-441f-4c67-9514-5f91ec40e6fd					Just Break Cafeteria	f		2025-07-04 11:32:23.337	2025-07-04 11:32:23.337	S5	CONFIRMED	957b0942-b4bf-4872-9bbe-25372064cda1	f	
33532f8a-7523-4900-880c-49bde5551042	5918dbf2-a767-4c9c-9f4f-af77823f1be4					McDonald's	f		2025-07-04 11:32:29.697	2025-07-04 11:32:29.697	S1	CONFIRMED	c6dace27-b9ab-4dc1-84f9-09e440734f04	f	
86cf5e52-a55d-4c54-b21d-2916c5253c83	5918dbf2-a767-4c9c-9f4f-af77823f1be4					McDonald's	f		2025-07-04 11:32:29.697	2025-07-04 11:32:29.697	S2	NOT_CONFIRMED	4b91e201-6351-46fc-a028-6eeb5666ae1d	f	
89954555-b24b-4c63-9732-09ccaf1cd9d8	5918dbf2-a767-4c9c-9f4f-af77823f1be4					McDonald's	f		2025-07-04 11:32:29.697	2025-07-04 11:32:29.697	S3	NOT_CONFIRMED	118e604b-0280-496a-8bae-21f021dd99fc	f	
f39204db-34b2-4e12-a85a-b39ebc795c6e	5918dbf2-a767-4c9c-9f4f-af77823f1be4					McDonald's	f		2025-07-04 11:32:29.697	2025-07-04 11:32:29.697	S4	NOT_CONFIRMED	d213ba81-c530-4f0b-9a6b-0f4b059d922b	f	
447c636e-0691-4df8-a863-17b7edb00412	5918dbf2-a767-4c9c-9f4f-af77823f1be4					McDonald's	f		2025-07-04 11:32:29.698	2025-07-04 11:32:29.698	S5	NOT_CONFIRMED	5793b32e-b0e1-4550-8427-f0f43e8bc7f7	f	
19991e5c-7d89-4539-94c9-89c579ca363b	5918dbf2-a767-4c9c-9f4f-af77823f1be4					McDonald's	f		2025-07-04 11:32:29.698	2025-07-04 11:32:29.698	S6	NOT_CONFIRMED	66b527fd-ef09-444a-b976-569fdb8e12a5	f	
61a3920f-71a7-4f1b-8091-5ecbb3937576	b5bf9c33-d1b6-4519-8ca5-f91c3822d575					baqla	f		2025-07-04 12:15:15.266	2025-07-04 12:15:15.266	S5	CONFIRMED	988ae71c-5ebf-4535-9fdf-bc7d1b86a51f	f	
ca5b5da0-6b20-483a-bc56-b0af41d70217	b5bf9c33-d1b6-4519-8ca5-f91c3822d575					Wahat Al Daher Baqala	f		2025-07-04 12:15:15.266	2025-07-04 12:15:15.266	S6	CONFIRMED	7ddecacb-81ad-40c8-ae6c-f6811d3ebbea	f	
c408876a-a348-4e9f-b836-38e0bf228c42	b5bf9c33-d1b6-4519-8ca5-f91c3822d575					AL noorain vef and fruits	f		2025-07-04 12:15:15.266	2025-07-04 12:15:15.266	S7	CONFIRMED	3c43a178-3881-4580-9e4a-ed96e56012e2	f	
f92d7793-59fd-4ef4-837a-0a4b4957c90f	b5bf9c33-d1b6-4519-8ca5-f91c3822d575					Al madeena Fruits and Vegetable shop	f		2025-07-04 12:15:15.266	2025-07-04 12:15:15.266	S8	CONFIRMED	ae2f98e5-9a68-4123-88d3-085c775930df	f	
e425189a-be3e-4215-9cb3-a7966e48d8ef	b5bf9c33-d1b6-4519-8ca5-f91c3822d575					Al madeena Fruits and Vegetable shop	f		2025-07-04 12:15:15.266	2025-07-04 12:15:15.266	S9	CONFIRMED	050d8712-6700-4002-8317-bfd838bb7ff1	f	
e3bdee82-ab60-44c3-bc2c-45d1be678bf7	b5bf9c33-d1b6-4519-8ca5-f91c3822d575					alwan grocery 	f		2025-07-04 12:15:15.266	2025-07-04 12:15:15.266	S10	CONFIRMED	83982303-85e8-4e60-9d35-505dc00859cb	f	
742845ef-df2d-40ff-8588-e325ba9b2ca1	b5bf9c33-d1b6-4519-8ca5-f91c3822d575					km trading	f		2025-07-04 12:15:15.266	2025-07-04 12:15:15.266	S11	NOT_CONFIRMED	7f318f67-03f7-48a2-802b-a269a672b6c0	f	
f6b2cb5a-6375-400c-8ac4-08882eda2ced	b5bf9c33-d1b6-4519-8ca5-f91c3822d575					km trading	f		2025-07-04 12:15:15.266	2025-07-04 12:15:15.266	S12	NOT_CONFIRMED	112b161e-505d-4d39-97e0-39959f26e5c0	f	
730929c9-85cf-46d1-995a-39ebc6d5b0dc	b5bf9c33-d1b6-4519-8ca5-f91c3822d575					Dara Grocery	f		2025-07-04 12:15:15.266	2025-07-04 12:15:15.266	S13	CONFIRMED	bf3f5b6e-3566-4032-b41b-db347bd08ff8	f	
10d0534a-7ce1-4d8c-a14d-349ac47949a6	b5bf9c33-d1b6-4519-8ca5-f91c3822d575					Noor Al Ward Grocery	f		2025-07-04 12:15:15.266	2025-07-04 12:15:15.266	S14	CONFIRMED	aed596db-607f-4421-96ac-b06dee24e7c2	f	
962b6e88-1f38-4fff-a8dd-cd8e9be89c85	03ceabeb-e0a6-4436-b4dc-22f6e9ce486a						f		2025-07-05 11:11:32.749	2025-07-05 11:11:32.749	S1	CONFIRMED	7ce33dd7-06eb-4518-9a72-f95c59d4996c	f	
3687490d-2d0b-4da8-91e6-484e4cec626b	0688a322-6cf0-46c1-be5b-16843424c70e	Abdel Hafez  Abualnadi	784199932516711			Eagle Environmental Services	f		2025-07-01 09:11:51.013	2025-07-01 09:11:51.013	S1	CONFIRMED	7066b770-f768-4777-bdf7-b8bebb598acc	f	
07565344-5033-449a-9f11-2fa5d562ad37	4729c61f-a469-43e7-aa08-0984f1ab506e	Abdel Hafez  Abualnadi	784199932516711			Eagle Environmental Services	f		2025-07-01 09:12:29.619	2025-07-01 09:12:29.619	S1	CONFIRMED	7066b770-f768-4777-bdf7-b8bebb598acc	f	
626483b0-03ff-4aeb-a9a8-cd525226cbff	0e5ed940-8b1c-4e20-94ff-d94366bf5a35	Abdel Hafez  Abualnadi	784199932516711			Eagle Environmental Services	f		2025-07-01 09:13:08.063	2025-07-01 09:13:08.063	S1	CONFIRMED	7066b770-f768-4777-bdf7-b8bebb598acc	f	
13cb7b74-d3ad-4fc1-8248-8693cfaf0ebf	03ceabeb-e0a6-4436-b4dc-22f6e9ce486a					Guld and safa diaries	f		2025-07-05 11:11:32.749	2025-07-05 11:11:32.749	S2	CONFIRMED	9909caeb-3642-42ce-801b-6c0e6c950125	f	
12e6118e-7cc7-4611-8ae4-0828861aa9b5	03ceabeb-e0a6-4436-b4dc-22f6e9ce486a					Guld and safa diaries	f		2025-07-05 11:11:32.749	2025-07-05 11:11:32.749	S3	CONFIRMED	31382e31-518b-4cf8-82ed-f93cdb4a5773	f	
be332f8c-518d-4697-9f20-1573296c88fd	03ceabeb-e0a6-4436-b4dc-22f6e9ce486a					Flowers	f		2025-07-05 11:11:32.749	2025-07-05 11:11:32.749	S4	CONFIRMED	17b8d5ce-ea34-4dd0-8ad0-92de5ea0fa91	f	
757489f7-4e67-4bc9-b322-c784ff432b0d	03ceabeb-e0a6-4436-b4dc-22f6e9ce486a						f		2025-07-05 11:11:32.749	2025-07-05 11:11:32.749	S5	NOT_CONFIRMED	798754bf-c3ce-4892-9daf-3006871e8c0e	f	
9cf8d256-4a5d-4d95-ae7f-9d90389e4a1a	03ceabeb-e0a6-4436-b4dc-22f6e9ce486a					al hor camping	f		2025-07-05 11:11:32.749	2025-07-05 11:11:32.749	S6	CONFIRMED	7a005915-670c-4199-9e04-ce158715c6e3	f	
cbe01c01-9154-45e4-87f8-36a182f80ed1	03ceabeb-e0a6-4436-b4dc-22f6e9ce486a					al hor camping	f		2025-07-05 11:11:32.749	2025-07-05 11:11:32.749	S7	NOT_CONFIRMED	39190b60-9974-4fa8-b466-3eb128e5b0cb	f	
75916292-628d-41c3-a8ab-c072b8ea1228	6e95257b-127a-4e5b-b68d-1d789339f69d	Morinka 				Bounce Middle East	f		2025-07-05 11:30:41.385	2025-07-05 11:30:41.385	S1	CONFIRMED	cb3772ca-5e8c-42d9-9f7f-a7cd829836f6	f	
ba37d6bb-d157-4a6c-8096-de53fb0a59ee	6e95257b-127a-4e5b-b68d-1d789339f69d	Erika Daza				Bounce Middle East	f		2025-07-05 11:30:41.385	2025-07-05 11:30:41.385	S2	CONFIRMED	cb3772ca-5e8c-42d9-9f7f-a7cd829836f6	f	
dae97611-433c-4989-b297-d53ced1bd774	6e95257b-127a-4e5b-b68d-1d789339f69d	Sara				Bounce Middle East	f		2025-07-05 11:30:41.385	2025-07-05 11:30:41.385	S3	CONFIRMED	cb3772ca-5e8c-42d9-9f7f-a7cd829836f6	f	
fbe266c6-a71a-4903-92bf-f0c1b649847a	6e95257b-127a-4e5b-b68d-1d789339f69d	Christina				Bounce Middle East	f		2025-07-05 11:30:41.385	2025-07-05 11:30:41.385	S4	CONFIRMED	cb3772ca-5e8c-42d9-9f7f-a7cd829836f6	f	
7c6ae1e2-c7d4-4041-b788-eece1db45e24	34d730a8-3aab-4892-92d1-e5cc3b928aae	Jivan Banjara			jeevan32j@gmail.com	McDonald's	f		2025-07-05 07:04:22.33	2025-07-05 07:04:22.33	S6	NOT_CONFIRMED	f43f9e88-a1c0-4c2b-81ca-5dcc3c83f16b	f	
84072c5f-da0e-4f50-859b-9fced89bd387	34d730a8-3aab-4892-92d1-e5cc3b928aae	Min Thiha		526782388	rahul60616@gmail.com	McDonald's	f		2025-07-05 07:04:22.33	2025-07-05 07:04:22.33	S7	NOT_CONFIRMED	200d65b2-7de6-4672-a7a6-f36709e836dd	f	
6619b6a8-98db-4283-9d05-b5ae4e209d1a	34d730a8-3aab-4892-92d1-e5cc3b928aae	Rita Rai			sr608750@gmail.com	McDonald's	t		2025-07-05 07:04:22.33	2025-07-05 07:04:22.33	S8	NOT_CONFIRMED	3fc50120-8acc-44fb-b88d-e6f2c0930c95	f	
1c387ef3-938c-4aba-a4d4-2cacf69149e7	34d730a8-3aab-4892-92d1-e5cc3b928aae	Pasang Dolma Tamang					f		2025-07-05 07:04:22.33	2025-07-05 07:04:22.33	S9	NOT_CONFIRMED	73d400e5-5e01-4abe-93fe-c5ce7d60baf3	f	
58d440a4-8882-4c22-942d-c834f6a7a60a	2ff62317-66db-492b-80cb-f5c2b83644d7					Your Destination for Juices 	f		2025-07-05 07:04:57.102	2025-07-05 07:04:57.102	S1	CONFIRMED	81c68035-22b9-42a3-b18f-719a1ad0403f	f	
c3fd5e19-22e1-40e5-abeb-91097c45fa5e	2ff62317-66db-492b-80cb-f5c2b83644d7					Tineh and Zaitoneh For Foodstuff 	f		2025-07-05 07:04:57.102	2025-07-05 07:04:57.102	S2	CONFIRMED	7d71dc97-a971-4c58-af26-01e3c1291a90	f	
8d303b02-c2eb-44db-b240-f09edbf61d4c	ae065564-1ddd-42ad-b7b7-e8f8af30568b	Devi Giri	784200525963409	505419200	giridevi695@gmail.com	McDonald's	t		2025-07-03 08:16:12.453	2025-07-03 08:16:12.453	S1	CONFIRMED	c6def147-bb5b-49ea-8b93-ee7fe08239d7	f	
48d03951-6382-4b49-bb29-3d6d509ef245	ae065564-1ddd-42ad-b7b7-e8f8af30568b	Punam Kunwar	784200382382479	566080232	PunamKunwar78@gmail.com	Mcdonald's	t		2025-07-03 08:16:12.453	2025-07-03 08:16:12.453	S2	CONFIRMED	20baba12-4977-4b00-abf2-a90464cb676d	f	
10d84831-fa07-4f35-a0bb-407eac508ff7	ae065564-1ddd-42ad-b7b7-e8f8af30568b	Sumana Shrestha 	784200447483296	561053069	sumanashrestha39@gmail.com	McDonald's	t		2025-07-03 08:16:12.453	2025-07-03 08:16:12.453	S3	CONFIRMED	069ba0a8-1bd0-4570-80be-3208c307f5be	f	
e2203650-727c-4221-8a54-f1a953712c6c	ae065564-1ddd-42ad-b7b7-e8f8af30568b	Minora Serangi Godama Vidanalage	784200014814113	509128307	minorajayasinghez@gmail.com	Mcdonald's	t		2025-07-03 08:16:12.453	2025-07-03 08:16:12.453	S4	CONFIRMED	cc56b9ec-d5f7-4358-ae4f-d58f5eb029db	f	
f9f51bf6-4201-4285-bc9d-7752bbb0f88b	ae065564-1ddd-42ad-b7b7-e8f8af30568b	Drishti Thapa	784200054042526	566227826	dristithapa225@gmail.com	McDonald's	t		2025-07-03 08:16:12.453	2025-07-03 08:16:12.453	S5	CONFIRMED	674ea7b9-213a-40f7-8297-2e376db1cfdb	f	
649eac5d-833b-43bb-939b-6a525d825d55	ae065564-1ddd-42ad-b7b7-e8f8af30568b	Ariyan Bhulun	784200225486065	506287122	ariyanbhulun@gmail.com	McDonald's	t		2025-07-03 08:16:12.453	2025-07-03 08:16:12.453	S6	CONFIRMED	9f05e154-eb82-403a-b244-126c03246b29	f	
5023714b-9734-4df7-8b97-76935f408ae1	ae065564-1ddd-42ad-b7b7-e8f8af30568b	Samir Ali	784199813147206	555862802	sammeerali7860@gmail.com	McDonald's	t		2025-07-03 08:16:12.453	2025-07-03 08:16:12.453	S7	CONFIRMED	09442fe5-ffa3-4d74-b2f5-44b0c0b4232c	f	
df452d34-d7e1-4925-ab84-781468fcbd29	2ff62317-66db-492b-80cb-f5c2b83644d7					Tineh and Zaitoneh For Foodstuff 	f		2025-07-05 07:04:57.102	2025-07-05 07:04:57.102	S3	CONFIRMED	5afdb776-b1be-4020-a995-fad90d1f27ab	f	
09ad6ef5-f8d7-45cd-9426-e511618cca2a	2ff62317-66db-492b-80cb-f5c2b83644d7					Tineh and Zaitoneh For Foodstuff 	f		2025-07-05 07:04:57.102	2025-07-05 07:04:57.102	S4	CONFIRMED	8dcd71d6-101e-4906-a0e8-317daffaa88b	f	
25aadc46-3f9a-4f03-8a97-bcf11e1a7a13	d4ce55cd-5df1-4d19-9e33-fdeec723c9b8	Abdel Hafez  Abualnadi	784199932516711	0565382491		Eagle Environmental Services	f		2025-07-01 09:10:44.624	2025-07-01 09:10:44.624	S1	CONFIRMED	\N	f	
bff16587-55ad-4a62-b301-fd20a87a5f01	ae065564-1ddd-42ad-b7b7-e8f8af30568b	Ranjit Tamang	784200330989466	507482003	tamangranjit465@gmail.com	McDonald's	t		2025-07-03 08:16:12.453	2025-07-03 08:16:12.453	S8	CONFIRMED	7c0650de-20f4-42fc-989c-bcd2766eb732	f	
25b6f53b-3d27-40dd-afa5-8d98b4d583b0	ae065564-1ddd-42ad-b7b7-e8f8af30568b	Sarishma Tamang	784200049433558	503087251	sarishmatamang7@gmail.com	McDonald's	t		2025-07-03 08:16:12.453	2025-07-03 08:16:12.453	S9	CONFIRMED	102deaa2-2455-47c9-b76e-68c54baa9aa7	f	
6fd32513-74d7-4d55-b3e7-8528e54c6ed3	ae065564-1ddd-42ad-b7b7-e8f8af30568b	Pranisha Shrestha	784200464249190	503997431	crestapranisa07@gmail.com	McDonald's	t		2025-07-03 08:16:12.453	2025-07-03 08:16:12.453	S10	CONFIRMED	a807da42-965f-4b32-b216-27ea8b4c523b	f	
a653ace6-1bc2-406f-909b-e31742152fb7	ae065564-1ddd-42ad-b7b7-e8f8af30568b	Rama Adhikari Rai	784199687010860	567731815	rrai48804@gmail.com	McDonald's	t		2025-07-03 08:16:12.453	2025-07-03 08:16:12.453	S11	CONFIRMED	cbbaa60d-3607-4547-b7b6-513b8f4d7e41	f	
93f9d13b-8294-44cf-b453-e759c2a5c9cf	b5bf9c33-d1b6-4519-8ca5-f91c3822d575					km trading	f		2025-07-04 12:15:15.266	2025-07-04 12:15:15.266	S15	NOT_CONFIRMED	38e99674-34de-49d6-8de8-de614d429af1	f	
8f2eb854-032b-4955-9976-ece807db48eb	6e95257b-127a-4e5b-b68d-1d789339f69d	Solomon Konosi				Bounce Middle East	f		2025-07-05 11:30:41.385	2025-07-05 11:30:41.385	S5	CONFIRMED	cb3772ca-5e8c-42d9-9f7f-a7cd829836f6	f	
1f7e61ff-a9e9-4f47-88ee-107d2919a0c9	6e95257b-127a-4e5b-b68d-1d789339f69d	Osama Elbayoul				Bounce Middle East	f		2025-07-05 11:30:41.385	2025-07-05 11:30:41.385	S6	CONFIRMED	cb3772ca-5e8c-42d9-9f7f-a7cd829836f6	f	
7bb302cb-c04f-468d-a3fe-57c2cfb268b6	6e95257b-127a-4e5b-b68d-1d789339f69d					Accor-Novotel	f		2025-07-05 11:30:41.385	2025-07-05 11:30:41.385	S9	NOT_CONFIRMED	1cdf0a50-c91a-4093-9d8c-d48a11aa330a	f	
9dfcec63-61c9-4f0e-9176-4dc13708a944	6e95257b-127a-4e5b-b68d-1d789339f69d					Gound Cafe 	f		2025-07-05 11:30:41.385	2025-07-05 11:30:41.385	S10	CONFIRMED	3bf282fe-f6dc-492c-8765-23230a382a2a	f	
a22d1415-697c-4d98-a453-93b6fb6b83b7	6e95257b-127a-4e5b-b68d-1d789339f69d					Gound Cafe 	f		2025-07-05 11:30:41.385	2025-07-05 11:30:41.385	S11	CONFIRMED	aa4ae4d4-0a84-45e0-9de8-9b60f96f44ab	f	
38bb8ce0-c72d-4645-b670-82a7184eb0d7	6e95257b-127a-4e5b-b68d-1d789339f69d					Chantilly Cafe 	f		2025-07-05 11:30:41.385	2025-07-05 11:30:41.385	S7	CONFIRMED	04f04f00-afae-4763-8b67-275c43f18618	f	
eea7a491-9364-417e-8806-a648ec0de79e	6e95257b-127a-4e5b-b68d-1d789339f69d					Chantilly Cafe 	f		2025-07-05 11:30:41.385	2025-07-05 11:30:41.385	S8	CONFIRMED	9542ce32-2006-4579-a0c3-c039dec39df2	f	
89e93fc3-35e4-4934-875c-1b181523fde7	6e95257b-127a-4e5b-b68d-1d789339f69d					Cevapi House Restaurant 	f		2025-07-05 11:30:41.385	2025-07-05 11:30:41.385	S12	CONFIRMED	03701de3-4a5a-48ca-9bce-bdf275f98bdd	f	
16689cb7-aaaf-4872-af44-92ae3d0cc9d9	6e95257b-127a-4e5b-b68d-1d789339f69d					Cevapi House Restaurant 	f		2025-07-05 11:30:41.385	2025-07-05 11:30:41.385	S13	CONFIRMED	e4ebd7c9-db2a-42fe-9568-28f329d09947	f	
e2caeb95-0796-4c10-bb52-9f339765d611	6e95257b-127a-4e5b-b68d-1d789339f69d					Cevapi House Restaurant 	f		2025-07-05 11:30:41.385	2025-07-05 11:30:41.385	S14	CONFIRMED	8ee4921a-e532-459e-a1fc-42cc2a3ea0df	f	
7a578cf7-fd3f-4742-b225-84057b1fe03a	6e95257b-127a-4e5b-b68d-1d789339f69d					Cevapi House Restaurant 	f		2025-07-05 11:30:41.385	2025-07-05 11:30:41.385	S15	CONFIRMED	45cc86a1-6bc1-4839-a7c6-d4d8dfdf379d	f	
be162523-aaba-4628-9697-383eaa2b0df8	08e147e3-90be-4ee0-b5ce-78f2a9862b4d					Ahmed Ali Refreshment 	f		2025-07-05 07:15:17.888	2025-07-05 07:15:17.888	S1	CONFIRMED	cb5b469b-025a-47de-b647-c1e3d50317ef	f	
ca79f597-07a3-4edc-b24d-8a5b4af1bafc	08e147e3-90be-4ee0-b5ce-78f2a9862b4d	Mahabu Alam Mojaher Miah 	784197139092940	0509846482		The Prince Cafe 	f		2025-07-05 07:15:17.888	2025-07-05 07:15:17.888	S2	CONFIRMED	a00c832c-b954-4447-8664-bbe1f0e06985	f	
1d7d1474-3e19-430a-882f-32aed861ecf2	f8109649-9db6-42a7-8b03-4ea280b77369					Al Khaleej Bakery 	f		2025-07-03 09:01:57.316	2025-07-03 09:01:57.316	S8	CONFIRMED	ba4ad0ed-b4bc-4b99-b8b4-3bbe2981753b	f	
ad17661f-f3a5-4b65-b100-d0182ce51803	f8109649-9db6-42a7-8b03-4ea280b77369	Muhammad Zakir Hossain	784199182142572	545696720	zakihossain19912023@gmail.com	Zad Khair Catering	f		2025-07-03 09:01:57.316	2025-07-03 09:01:57.316	S12	CONFIRMED	53d4c8f1-207b-4925-88a8-bca522bce2d9	f	
7e01d49c-0f23-4935-b32d-b9630b25477e	f8109649-9db6-42a7-8b03-4ea280b77369	Muhammad Kobir Hossain	784199599180843	502790198		Zad Al Khair Catering	f		2025-07-03 09:01:57.316	2025-07-03 09:01:57.316	S13	CONFIRMED	a2067b4e-d252-465c-8404-6a270a09dbe3	f	
78309208-8e07-4c66-a1e3-b2e63605efc1	f8109649-9db6-42a7-8b03-4ea280b77369					Zad Al Khair Catering	f		2025-07-03 09:01:57.316	2025-07-03 09:01:57.316	S14	CONFIRMED	9d28d422-ca43-4ade-85eb-89bca10c0bec	f	
02476391-8597-4cae-be95-51731d6176c7	f8109649-9db6-42a7-8b03-4ea280b77369	Lali Sunar	784200563656998	506396983	handebk79@gmail.com	Café Kudumbasree Restaurant\t	f		2025-07-03 09:01:57.316	2025-07-03 09:01:57.316	S9	CONFIRMED	a0e10b65-64bf-4f55-b147-3cf9f75f0b18	f	
3ffbcabb-caef-472b-bdf6-2eaead05fe42	f8109649-9db6-42a7-8b03-4ea280b77369	Mohammad Arbaz Mohammad	784199163829692	569537090		Al Qadhi Restaurant 	f		2025-07-03 09:01:57.316	2025-07-03 09:01:57.316	S1	CONFIRMED	c73dae09-e004-46d4-b9d8-3c0b7b82d00a	f	
721b9db8-6c53-44c7-b7c6-24283782767d	f8109649-9db6-42a7-8b03-4ea280b77369	Shiblu Miah Md	784199029346022	543902032	shiblum156@gmail.com	Bangla Baraka Restaurant 	f		2025-07-03 09:01:57.316	2025-07-03 09:01:57.316	S2	CONFIRMED	1bb6571c-8be8-4053-8a96-15657fb03f52	f	
5cc83246-e0e0-4fb9-98f1-d4748534cadb	f8109649-9db6-42a7-8b03-4ea280b77369	Naeem Khan 	784197785427440	562464045	talha.naeem.khan4045@gmail.com	Peshawari Food Restaurant \t	f		2025-07-03 09:01:57.316	2025-07-03 09:01:57.316	S3	CONFIRMED	b057dc6b-4858-4b75-b667-f8347e2ca26f	f	
6146c9b8-417d-45fe-99bc-4f996e4343c0	f8109649-9db6-42a7-8b03-4ea280b77369	Md Masud Rana	784199468081304	554088962	masud2636329@gmail.com	Sofra Baniyas Restaurant\t	f		2025-07-03 09:01:57.316	2025-07-03 09:01:57.316	S4	CONFIRMED	393e6c59-08ea-4190-b0cf-a43cb9695471	f	
33945061-042e-435a-b532-57124f6b88b9	f8109649-9db6-42a7-8b03-4ea280b77369	Syed Irshaad Syed	784199429286935	525137391	syedirshaad29@gmail.com	Best Biriyani Restaurant\t	f		2025-07-03 09:01:57.316	2025-07-03 09:01:57.316	S5	CONFIRMED	25f0521d-7471-4207-aece-b49b2b3f4d0f	f	
2144e5cf-d797-42ea-bc4b-5acad17837f1	f8109649-9db6-42a7-8b03-4ea280b77369	Mohd Monis 	784199317797787	543448624	mohdmonis101993@gmail.com	Best Biriyani Restaurant\t	f		2025-07-03 09:01:57.316	2025-07-03 09:01:57.316	S6	CONFIRMED	02bd0f79-22be-4667-b5f9-0198c04aee6a	f	
780c1588-f94c-4a89-b9ae-e5e18343bbd8	f8109649-9db6-42a7-8b03-4ea280b77369	Aakash Kumar	784199840617031	547427607	goundaakash2024@gmail.com	Lazord Café \t	f		2025-07-03 09:01:57.316	2025-07-03 09:01:57.316	S7	CONFIRMED	c201b1ca-ea9f-48e8-8c9a-81ebc47560c5	f	
298fc8b0-fdad-4e87-bdd5-29a1557c6ad4	bdf8617b-596e-4071-ac63-8a2e5116f55f	Christine Flores Dellova 	784200182273688	0562411791	cdellova103@gmail.com	Cravia Abu Dhabi	f		2025-07-03 10:42:17.281	2025-07-03 10:42:17.281	S1	CONFIRMED	c20ec36a-945b-4427-9967-c51493486f85	f	
04079338-e13d-4266-96ca-522639525d22	bdf8617b-596e-4071-ac63-8a2e5116f55f	Mostafa Ahmad Kabbaro 	784200468759202	0559859366	safokabaro31@gmail.com	Bounce Middle East	f		2025-07-03 10:42:17.281	2025-07-03 10:42:17.281	S8	CONFIRMED	cb3772ca-5e8c-42d9-9f7f-a7cd829836f6	f	
f4490815-f5f2-444c-85d5-8fd342398dad	bdf8617b-596e-4071-ac63-8a2e5116f55f	Thara Phe Kyaw 	784199574421774	0567573559	tharaphe933@gmail.com	Sushi House 	f		2025-07-03 10:42:17.281	2025-07-03 10:42:17.281	S10	CONFIRMED	4f223f59-1ad3-4583-bea9-ce9cce079aa1	f	
8596f5e7-85ef-4470-aa6b-c3cbb6ceb475	bdf8617b-596e-4071-ac63-8a2e5116f55f	Oluwaseun Lekan Babatunde	784199091127219	0524750797	olamilekkon25@gmail.com	BTWN Restaurants and Coffe 	f		2025-07-03 10:42:17.281	2025-07-03 10:42:17.281	S6	CONFIRMED	245d075a-d2bf-4145-b9f6-f472cc83ae8f	f	
a9476c95-acb5-40b1-91c7-fb0455f7d737	bdf8617b-596e-4071-ac63-8a2e5116f55f	Khadija Bihi Abdulsalam	784196565938022	0508127775	kattaldo@yahoo.com	Tamntinou Sweets 	f		2025-07-03 10:42:17.281	2025-07-03 10:42:17.281	S12	CONFIRMED	c8fe266e-3c4b-4c39-9d1c-9910050afaac	f	
dfdcc097-bd68-40c7-b175-adffaccda1bc	bdf8617b-596e-4071-ac63-8a2e5116f55f	Adrian Lopez Ramos 	784199812899807	0507958470	kingadrianr26@gmail.com	Cravia	f		2025-07-03 10:42:17.281	2025-07-03 10:42:17.281	S2	CONFIRMED	31bf8be1-4805-49bb-b47a-fc815ff2ae12	f	
ed26005e-49a0-436e-a559-aa156963b86f	bdf8617b-596e-4071-ac63-8a2e5116f55f	Bryan Pangilinan Dizon 	784199022988978	0543243510	bryanpanhilinan@gmail.com	Cravia	f		2025-07-03 10:42:17.281	2025-07-03 10:42:17.281	S3	CONFIRMED	f6e91044-6b50-4932-b005-838bf1761c46	f	
1ceadce8-fb98-4454-838c-8481423e0c61	bdf8617b-596e-4071-ac63-8a2e5116f55f	Carl Kevin Maigue Tamayo 	784199335675452	0543835087	ceekei1993@gmail.com	Cravia	f		2025-07-03 10:42:17.281	2025-07-03 10:42:17.281	S4	CONFIRMED	728cb02f-aca7-40d8-b5fe-4a0137818ca1	f	
ae590acf-7c1e-4272-864c-5be3fbd2db00	bdf8617b-596e-4071-ac63-8a2e5116f55f	Boshra Yousef Ayesh 	784200385437437	0565559329	bushraaesh8@gmail.com	Bounce Middle East	f		2025-07-03 10:42:17.281	2025-07-03 10:42:17.281	S9	CONFIRMED	44fb1144-8258-4ff7-9d95-92165fa68e42	f	
f9e5c954-34f2-4686-8b40-299b76710772	10d349ca-7c77-476d-94ad-61ce1d0da530	Khaleel Ibrahim Saeed AlKoufhi	784199894782319			Eagle Environmental Services - Abu Dhabi	t		2025-07-05 07:42:04.04	2025-07-05 07:42:04.04	S1	CONFIRMED	c4f2923c-c92f-426c-9e35-23a76f40ebf8	f	
de9f1244-fe00-4190-9eee-a58b8a692df8	10d349ca-7c77-476d-94ad-61ce1d0da530	Ragab Nabeel Mohammad Rasheed	784199715401941			Eagle Environmental Services - Abu Dhabi	f		2025-07-05 07:42:04.04	2025-07-05 07:42:04.04	S2	CONFIRMED	c4f2923c-c92f-426c-9e35-23a76f40ebf8	f	
5ea8f488-f192-44ad-8b5f-b6b74d9c34f4	bdf8617b-596e-4071-ac63-8a2e5116f55f	Khushi Rai Bir Bahadur 	784200394898215	0561729101	khushirai1844@gmail.com	Bedashing Beauty Lounge	f		2025-07-03 10:42:17.281	2025-07-03 10:42:17.281	S5	CONFIRMED	61952475-8b12-46b9-8456-da3fb737fb7d	f	
26d9fbdd-4179-4bc0-b23d-3aa3a7a3fd6e	2467666f-e294-4e89-bfab-fdb4d39727f9					Grand mart	f		2025-07-04 10:00:10.458	2025-07-04 10:00:10.458	S1	CONFIRMED	0fc1b73a-58b3-4a76-ab2a-540a43fdfd44	f	
6bced0ac-878f-463c-b6b6-abf73965d401	2467666f-e294-4e89-bfab-fdb4d39727f9					Grand mart	f		2025-07-04 10:00:10.458	2025-07-04 10:00:10.458	S2	CONFIRMED	f977eec9-8a04-42c5-9d0c-c81fd19babfd	f	
fb76e501-a362-44a0-9b3c-7bb49e207042	2467666f-e294-4e89-bfab-fdb4d39727f9					Grand mart	f		2025-07-04 10:00:10.458	2025-07-04 10:00:10.458	S3	CONFIRMED	32f456df-aa05-4b82-916c-b2dcb3ccafae	f	
6c79d983-9871-4602-bf7b-3e147aa6353a	2467666f-e294-4e89-bfab-fdb4d39727f9					Grand mart	f		2025-07-04 10:00:10.458	2025-07-04 10:00:10.458	S4	CONFIRMED	695382fd-2793-4557-a0bf-16034934e9fa	f	
41d2dddf-edc4-4704-a11b-6b54dca6f84d	2467666f-e294-4e89-bfab-fdb4d39727f9					Cro Bakery and Cafe	f		2025-07-04 10:00:10.458	2025-07-04 10:00:10.458	S5	CONFIRMED	33581069-b3ab-4fff-9605-007292a0e95e	f	
64f9876b-8c45-4006-a040-3bbe86920c0f	6824e9de-19c5-40a3-8dae-bf47f983c486	Anna Marie Advincula Faustino	784197695370961	0566218478	gotonginamorestaurant@gmail.com	Gotahan Ok Nato Restaurant 	f		2025-07-04 08:02:48.508	2025-07-04 08:02:48.508	S1	CONFIRMED	46f560fc-bd3c-437b-9263-41ea550bba55	f	
d1e97523-74f9-4b51-a0df-31fa499c393b	6824e9de-19c5-40a3-8dae-bf47f983c486	John Ericson Namuco Bunag 	784199764383834	0581274208	ericsonbunag160@gmail.com	Oxygen Restaurant 	f		2025-07-04 08:02:48.508	2025-07-04 08:02:48.508	S2	CONFIRMED	9e8b8172-98b3-4e2d-a47c-722045135739	f	
705bd7cc-e27c-4a09-a73c-636ebbb640b9	6824e9de-19c5-40a3-8dae-bf47f983c486	Glory Assangaahngwa Lun	784199681357879	0569044568	Glorylum10@gmail.com	BTWN Restaurants and Coffe	f		2025-07-04 08:02:48.508	2025-07-04 08:02:48.508	S3	CONFIRMED	bd113a5f-9785-483d-88ac-60aad4de5319	f	
7d3371ef-2402-4e85-8b84-52630b261a1b	6824e9de-19c5-40a3-8dae-bf47f983c486	Sabuj Hawlader Sarejan 	784199555642448	0505737314	hawladarsobuj28@gmail.com	Oxygen Restaurant 	f		2025-07-04 08:02:48.508	2025-07-04 08:02:48.508	S4	CONFIRMED	a9f7e02d-4c8d-4796-9993-48910055a64a	f	
705eee77-71ed-4e37-9be2-e8ccbe5e2f32	6824e9de-19c5-40a3-8dae-bf47f983c486	Nilantha Chathuranga 	784198216529259	0562881375	nilanthamd1982@gmail.com	Oxygen Restaurant 	f		2025-07-04 08:02:48.508	2025-07-04 08:02:48.508	S5	CONFIRMED	84e99f0c-c4b0-4bf7-870e-16be74abeb00	f	
a9f038d2-9cdc-4ee1-ac30-1ebaec6c028e	7249bb19-2425-4574-b18c-772c7004aab9					Cro Bakery and Cafe	f		2025-07-05 05:20:31.883	2025-07-05 05:20:31.883	S12	CONFIRMED	3416ccee-a6ae-48e6-b81d-562c98859ef7	f	
40d64094-9c73-4abe-a26c-643ec6d89f6f	6824e9de-19c5-40a3-8dae-bf47f983c486	Chandra Prakash Joshi 	784198215985098	0543859626	cjchandraprakash1@gmail.com	Oxygen Restaurant 	f		2025-07-04 08:02:48.508	2025-07-04 08:02:48.508	S6	CONFIRMED	228ff735-1886-45d0-b5ad-48fbad7d72ae	f	
ebf2b7d3-ec1e-4620-8930-4af01a48a3ec	6824e9de-19c5-40a3-8dae-bf47f983c486	Roy Onza Chan 	784199926873136	0564766051	rchan4660@gmail.com	Oxygen Restaurant 	f		2025-07-04 08:02:48.508	2025-07-04 08:02:48.508	S7	CONFIRMED	f0adcb4d-e6d7-48df-91e2-3b518fe2b8ce	f	
e7ee7265-3c48-44bf-b494-18a0ff212845	6824e9de-19c5-40a3-8dae-bf47f983c486	Aimae Jane Orota 	784199239763982	0568754964	aimaejaneclaveria@gmail.com	Oxygen Restaurant 	f		2025-07-04 08:02:48.508	2025-07-04 08:02:48.508	S8	CONFIRMED	24ecbc9b-f911-47c7-9469-ad75a8da8b12	f	
90dfc0a0-bf1f-4fa2-8e47-431d9cfaec50	6824e9de-19c5-40a3-8dae-bf47f983c486	Lara Jeresa Sedigo Sevilleno 	784199910825548	0556821894	sevillenolarajeresa@gmail.com	Oxygen Restaurant 	f		2025-07-04 08:02:48.508	2025-07-04 08:02:48.508	S9	CONFIRMED	48899022-3fd6-400c-a7f3-7f3c43d42425	f	
221b3e11-e681-469c-bf0e-a05e89d7a6ea	6824e9de-19c5-40a3-8dae-bf47f983c486	Christie Ibao Senio 	784199767153754	0561809130	christiesenio604@gmail.como	Oxygen Restaurant 	f		2025-07-04 08:02:48.508	2025-07-04 08:02:48.508	S10	CONFIRMED	c127f4a8-4b1b-476a-a92f-0df381142290	f	
a8823da2-d24a-40ef-8f59-25017c1b59bd	6824e9de-19c5-40a3-8dae-bf47f983c486	Manilka Malshan Weerakoon	784200032068205	0554877052	manilkamalshan2000@gmail.com	Oxygen Restaurant 	f		2025-07-04 08:02:48.508	2025-07-04 08:02:48.508	S11	CONFIRMED	bf4233c7-049d-4824-a0ab-7c908a16728f	f	
d85a1811-3e1f-4e90-b077-3af52d771c14	6824e9de-19c5-40a3-8dae-bf47f983c486	Kavishka Lakshana Pradeep 	784200232213379	0589518772	kavishkalakshan805@gmail.com	Oxygen Restaurant 	f		2025-07-04 08:02:48.508	2025-07-04 08:02:48.508	S12	CONFIRMED	772fe6ba-1aea-49f7-819e-3a6ba38c547c	f	
f343abb9-b639-48e0-a918-211f6ff31f8f	2467666f-e294-4e89-bfab-fdb4d39727f9					Cro Bakery and Cafe	f		2025-07-04 10:00:10.458	2025-07-04 10:00:10.458	S6	CONFIRMED	37fecb28-faea-449f-916f-f2eba5b3aa8d	f	
fc61ed53-7adc-45fb-b137-e5f057314d79	2467666f-e294-4e89-bfab-fdb4d39727f9					Cro Bakery and Cafe	f		2025-07-04 10:00:10.458	2025-07-04 10:00:10.458	S7	CONFIRMED	73e76091-354a-475f-a154-e27da6efce5f	f	
e57ccb82-0afa-4894-91a0-39eebd34b9b6	2467666f-e294-4e89-bfab-fdb4d39727f9					Cro Bakery and Cafe	f		2025-07-04 10:00:10.458	2025-07-04 10:00:10.458	S8	CONFIRMED	5e69e1ef-b83d-4709-8c14-20ac942f8438	f	
27d3b0f4-4069-4188-9431-6a263f768c6d	2467666f-e294-4e89-bfab-fdb4d39727f9					Cro Bakery and Cafe	f		2025-07-04 10:00:10.458	2025-07-04 10:00:10.458	S9	CONFIRMED	50eede9c-ac48-4c76-91bd-479fe948e0c6	f	
5b7ad6c6-4a60-4db7-8b4c-0d69c2a20258	2467666f-e294-4e89-bfab-fdb4d39727f9					Cro Bakery and Cafe	f		2025-07-04 10:00:10.458	2025-07-04 10:00:10.458	S10	CONFIRMED	2c9e4e69-4c4d-40fd-b573-d3350961941a	f	
5a0b054b-241e-4fb7-9306-5905803b6bc1	7249bb19-2425-4574-b18c-772c7004aab9					Cro Bakery and Cafe	f		2025-07-05 05:20:31.883	2025-07-05 05:20:31.883	S13	CONFIRMED	707998e9-3cc0-47ca-ae6a-7254e79c2157	f	
49c50181-aec1-4dac-ab1d-2a355730dc04	77b7284c-93f5-4e5a-b1da-7933f8641b7e					\tBurger Stop Cafeteria\t	f		2025-07-03 11:14:11.27	2025-07-03 11:14:11.27	S1	CONFIRMED	51083fe4-ada8-4675-acfd-ce4c22f419e4	f	
308d4112-4478-44c8-b61d-8d98662045ab	77b7284c-93f5-4e5a-b1da-7933f8641b7e			0502333157		Burger Stop Cafeteria	f		2025-07-03 11:14:11.27	2025-07-03 11:14:11.27	S2	CONFIRMED	6eb88f75-61cb-4324-b127-6ac619450603	f	
762a8f6f-3c3f-49cb-a8a1-2c09e5cd1afc	77b7284c-93f5-4e5a-b1da-7933f8641b7e					Zad Al Khair Catering	f		2025-07-03 11:14:11.27	2025-07-03 11:14:11.27	S3	CONFIRMED	073a3b7e-f658-4ec9-bb73-fe6ab6089c11	f	
75bf4e8d-812e-48b5-b0a0-bfb99acb512b	77b7284c-93f5-4e5a-b1da-7933f8641b7e					Zad Al Khair Catering	f		2025-07-03 11:14:11.27	2025-07-03 11:14:11.27	S4	CONFIRMED	2ee49c70-056b-4a54-a156-d4f04c66a735	f	
6faa375b-a4df-432d-a934-d81cb1dcf337	77b7284c-93f5-4e5a-b1da-7933f8641b7e					Zad Al Khair Catering \t	f		2025-07-03 11:14:11.27	2025-07-03 11:14:11.27	S5	CONFIRMED	2d3aa439-9ef2-48c3-9b9c-9af3e34f60c4	f	
b59ed3a1-7501-420e-bfc6-8d5029bfbe19	77b7284c-93f5-4e5a-b1da-7933f8641b7e					Delicacy Vita Flowers and Sweets\t	f		2025-07-03 11:14:11.27	2025-07-03 11:14:11.27	S6	CONFIRMED	c3caebf1-57a8-416f-9b99-168dd82d6843	f	
f39ada6f-d576-495d-9ac4-a980a735be8f	7249bb19-2425-4574-b18c-772c7004aab9					Coriander Restaurant \t	f		2025-07-05 05:20:31.883	2025-07-05 05:20:31.883	S14	CONFIRMED	fd736fee-e6be-4f71-bfcc-55004102d7b1	f	
25592c23-0197-4a9b-b780-5dfb2fdd712c	7249bb19-2425-4574-b18c-772c7004aab9					Coriander Restaurant \t	f		2025-07-05 05:20:31.883	2025-07-05 05:20:31.883	S15	CONFIRMED	ea71509f-cd3d-4cb7-bb36-dc3f86a72a22	f	
98e6f734-84d7-4927-a993-6281cf23aae0	e10222f4-a1e4-43e0-8dd2-2cb29a2157bc					Patchi	f		2025-07-04 08:44:20.124	2025-07-04 08:44:20.124	S1	CONFIRMED	6c8a9215-2c49-4bbd-a84e-74dc2c8fc493	f	
5b5575f1-e718-4d5c-9474-6c55243a1ad6	77b7284c-93f5-4e5a-b1da-7933f8641b7e					Lamars rest and café	f		2025-07-03 11:14:11.27	2025-07-03 11:14:11.27	S7	CONFIRMED	c2f4a820-9999-4fce-b19e-7c6682adf04a	f	
e27a3256-e001-4978-904b-393d5fc5c374	77b7284c-93f5-4e5a-b1da-7933f8641b7e					Lamars rest and café	f		2025-07-03 11:14:11.27	2025-07-03 11:14:11.27	S8	CONFIRMED	f5884e30-e4ce-491a-b0b7-a19928cf4fdc	f	
b671931e-7f03-4d0d-af80-f0ac452a72a2	77b7284c-93f5-4e5a-b1da-7933f8641b7e					Lamars rest and café	f		2025-07-03 11:14:11.27	2025-07-03 11:14:11.27	S9	CONFIRMED	6ad279d3-e91b-4d62-9a74-4f86a770a26c	f	
20d7c55b-4b3e-4155-8248-8bcfd190b3f2	77b7284c-93f5-4e5a-b1da-7933f8641b7e					Lamars rest and café	f		2025-07-03 11:14:11.27	2025-07-03 11:14:11.27	S10	CONFIRMED	acb41c75-2a87-40a6-b8fa-20306d224edf	f	
35ce4053-1149-41e1-8c52-af8d84e5f205	77b7284c-93f5-4e5a-b1da-7933f8641b7e					Lamars rest and café	f		2025-07-03 11:14:11.27	2025-07-03 11:14:11.27	S11	CONFIRMED	d9d625df-e611-4201-8607-361d6f5632d5	f	
a4d14340-ea0e-4908-9095-95043cc5c544	77b7284c-93f5-4e5a-b1da-7933f8641b7e					Tierra speciality coffe\t	f		2025-07-03 11:14:11.27	2025-07-03 11:14:11.27	S12	CONFIRMED	16fc9581-58fa-4ea1-8f98-25ba1c959dd0	f	
60a07c31-dd04-4ac1-a5ac-469a3b9039bb	77b7284c-93f5-4e5a-b1da-7933f8641b7e					Al Noor Modern Bakery	f		2025-07-03 11:14:11.27	2025-07-03 11:14:11.27	S13	CONFIRMED	b263a355-5ba9-4269-b257-b888eb9e8719	f	
1be1ebb5-df37-4bee-b5d4-295e64481a9e	77b7284c-93f5-4e5a-b1da-7933f8641b7e					Al Noor Modern Bakery	f		2025-07-03 11:14:11.27	2025-07-03 11:14:11.27	S14	CONFIRMED	0f605fd0-c2c3-43fd-9135-ba7144722905	f	
675c44e5-4633-4703-9658-9f17c8c764ed	77b7284c-93f5-4e5a-b1da-7933f8641b7e					Al Noor Modern Bakery	f		2025-07-03 11:14:11.27	2025-07-03 11:14:11.27	S15	CONFIRMED	f58f377c-fef7-4122-ad2a-79bd15dd059a	f	
11725984-a26c-413b-a68d-fed2b44a79b9	e10222f4-a1e4-43e0-8dd2-2cb29a2157bc					Patchi	f		2025-07-04 08:44:20.124	2025-07-04 08:44:20.124	S2	CONFIRMED	57caf293-051d-49b5-bbbf-32739792051b	f	
0b1d8c45-4bb6-43eb-ba39-06b1af0f4a39	e10222f4-a1e4-43e0-8dd2-2cb29a2157bc					Patchi	f		2025-07-04 08:44:20.124	2025-07-04 08:44:20.124	S3	CONFIRMED	46cd49f3-154d-4a98-a7de-b395ad89b5e6	f	
e1c63422-5e5d-4d41-a2a9-d309ef199a61	e10222f4-a1e4-43e0-8dd2-2cb29a2157bc					Al Maya 	f		2025-07-04 08:44:20.124	2025-07-04 08:44:20.124	S4	CONFIRMED	6c6d98c5-ecae-4eb3-83be-780e2e49fa1a	f	
9221e074-5be6-418e-925f-e51833e1366c	e10222f4-a1e4-43e0-8dd2-2cb29a2157bc					Your Destination for Juices 	f		2025-07-04 08:44:20.124	2025-07-04 08:44:20.124	S5	CONFIRMED	4d93101e-a2a5-4d27-83df-5a73d912db28	f	
fca4010e-e94a-46aa-8d8c-19a647efd8d7	e10222f4-a1e4-43e0-8dd2-2cb29a2157bc					Your Destination for Juices 	f		2025-07-04 08:44:20.124	2025-07-04 08:44:20.124	S6	CONFIRMED	58f11666-6803-4aa2-8745-85ccad0f5f9b	f	
b98f6520-c2c6-4691-894b-ae8d3fb336a0	e10222f4-a1e4-43e0-8dd2-2cb29a2157bc					Tineh and Zaitoneh For Foodstuff 	f		2025-07-04 08:44:20.124	2025-07-04 08:44:20.124	S7	CONFIRMED	3fd16529-300f-433c-9c88-fb2ac9518588	f	
de58597b-e823-488f-a512-655a929c6764	e10222f4-a1e4-43e0-8dd2-2cb29a2157bc					Tineh and Zaitoneh For Foodstuff 	f		2025-07-04 08:44:20.124	2025-07-04 08:44:20.124	S8	CONFIRMED	cbca6384-16fc-4063-992a-a88f6522024a	f	
c0556eea-a7ab-4db0-ac31-29d6a1244f7b	e10222f4-a1e4-43e0-8dd2-2cb29a2157bc					Tineh and Zaitoneh For Foodstuff 	f		2025-07-04 08:44:20.124	2025-07-04 08:44:20.124	S9	CONFIRMED	3d529acb-7083-4f99-b9f2-bc09f181c651	f	
e83376bf-bb53-495a-91be-2d32c0ae1b43	e10222f4-a1e4-43e0-8dd2-2cb29a2157bc					Modern Mood General Trading 	f		2025-07-04 08:44:20.124	2025-07-04 08:44:20.124	S10	CONFIRMED	4732ca6d-b40e-4683-93df-b5afc83681a6	f	
d78e0287-4c32-4357-bc65-a023e5d1f902	e10222f4-a1e4-43e0-8dd2-2cb29a2157bc					Modern Mood General Trading 	f		2025-07-04 08:44:20.124	2025-07-04 08:44:20.124	S11	CONFIRMED	2f15a5c8-4ea9-48eb-912f-34941ce6a40d	f	
ff583759-6737-4a87-b9b6-0706df953371	2467666f-e294-4e89-bfab-fdb4d39727f9					Cro Bakery and Cafe	f		2025-07-04 10:00:10.458	2025-07-04 10:00:10.458	S11	CONFIRMED	e181b181-38ee-4b36-8f7e-7312d19d9b95	f	
73b76b85-436c-41fe-8ffa-22e327210a8d	2467666f-e294-4e89-bfab-fdb4d39727f9					Cro Bakery and Cafe	f		2025-07-04 10:00:10.458	2025-07-04 10:00:10.458	S12	CONFIRMED	5db504ae-199a-4240-9e14-4115e822be44	f	
28132b3c-f396-46a5-af70-1ceda15df65d	2467666f-e294-4e89-bfab-fdb4d39727f9					Cro Bakery and Cafe	f		2025-07-04 10:00:10.458	2025-07-04 10:00:10.458	S13	CONFIRMED	ced44939-c31a-4f37-a74b-ece8650004d3	f	
732c171d-e17e-4600-96f7-41b481d14d13	2467666f-e294-4e89-bfab-fdb4d39727f9					Cro Bakery and Cafe	f		2025-07-04 10:00:10.458	2025-07-04 10:00:10.458	S14	CONFIRMED	50c2e7cf-ebaf-46a8-909d-1021d21ba1c7	f	
04370c33-eda0-4f3f-adbe-8696dadff454	2467666f-e294-4e89-bfab-fdb4d39727f9					Cro Bakery and Cafe	f		2025-07-04 10:00:10.458	2025-07-04 10:00:10.458	S15	CONFIRMED	5adad621-9738-437d-a4f5-46a1e18b8eb5	f	
f4c52ef4-a19d-4021-a1b0-9ad1934b2c5f	7249bb19-2425-4574-b18c-772c7004aab9					Grand mart	f		2025-07-05 05:20:31.883	2025-07-05 05:20:31.883	S1	CONFIRMED	0f69334d-7b9f-4c91-a7d6-36d322afe360	f	
dc314100-a5ae-4e3e-9f28-dadfe4aec824	7249bb19-2425-4574-b18c-772c7004aab9					Grand mart	f		2025-07-05 05:20:31.883	2025-07-05 05:20:31.883	S2	CONFIRMED	effb4dd6-3b9e-467b-bebe-8c9f64acbe4a	f	
b730a695-310c-47e7-b64b-c066e16c15b6	7249bb19-2425-4574-b18c-772c7004aab9					Grand mart	f		2025-07-05 05:20:31.883	2025-07-05 05:20:31.883	S3	CONFIRMED	94ceab2a-5ad8-4f9b-bb66-396c83989458	f	
531d333e-b3e0-408d-88ab-cafda5b4f3b3	7249bb19-2425-4574-b18c-772c7004aab9					Grand mart	f		2025-07-05 05:20:31.883	2025-07-05 05:20:31.883	S4	CONFIRMED	2a20e14f-9b1c-46a5-8732-585562e37f2f	f	
9f895f22-f4ee-4327-a872-0b61afd37f01	7249bb19-2425-4574-b18c-772c7004aab9					Cro Bakery and Cafe	f		2025-07-05 05:20:31.883	2025-07-05 05:20:31.883	S5	CONFIRMED	d771a4e6-ac27-48ad-ab8c-9dc3e79a35d0	f	
81237bc1-e8e8-4c50-9044-821b2623587d	7249bb19-2425-4574-b18c-772c7004aab9					Cro Bakery and Cafe	f		2025-07-05 05:20:31.883	2025-07-05 05:20:31.883	S6	CONFIRMED	f221ac27-6e72-4fe1-9774-57b2b075d127	f	
e9a6dbd9-647c-4b49-a48b-e19f06484016	7249bb19-2425-4574-b18c-772c7004aab9					Cro Bakery and Cafe	f		2025-07-05 05:20:31.883	2025-07-05 05:20:31.883	S7	CONFIRMED	f56d0ebc-4b95-4340-8fe2-18be93e9de68	f	
d395f788-0603-49df-a5a3-79ae7c24d1e2	7249bb19-2425-4574-b18c-772c7004aab9					Cro Bakery and Cafe	f		2025-07-05 05:20:31.883	2025-07-05 05:20:31.883	S8	CONFIRMED	2f57b090-f51b-4da2-9547-f74b6a8c8b45	f	
b91b3735-25d8-48ed-a463-397d4a3b3fc1	7249bb19-2425-4574-b18c-772c7004aab9					Cro Bakery and Cafe	f		2025-07-05 05:20:31.883	2025-07-05 05:20:31.883	S9	CONFIRMED	5798e395-88a6-4e9b-b8a2-f2cb1e3e9a43	f	
8b219351-f9c9-4b43-969f-b4dc4437c6fc	7249bb19-2425-4574-b18c-772c7004aab9					Cro Bakery and Cafe	f		2025-07-05 05:20:31.883	2025-07-05 05:20:31.883	S10	CONFIRMED	c959373f-cc47-4ad7-97fd-142a66a7162d	f	
5ead733d-fb08-4788-9f04-e007dfd0e340	7249bb19-2425-4574-b18c-772c7004aab9					Cro Bakery and Cafe	f		2025-07-05 05:20:31.883	2025-07-05 05:20:31.883	S11	CONFIRMED	69d95ac7-e4e1-455d-aa8f-c544a8140eea	f	
\.


--
-- Data for Name: Language; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Language" (id, name, "createdAt", "updatedAt") FROM stdin;
19fb92ce-85fe-4673-8a17-31cc6a204297	English	2025-05-13 16:34:47.944	2025-05-13 16:34:47.944
85ac039b-c015-47e8-afee-0d09d4716f63	Arabic	2025-05-15 12:55:41.133	2025-05-15 12:55:41.133
afe9d414-6434-4ec2-8901-92f22eafa437	Malayalam	2025-05-15 12:55:48.27	2025-05-15 12:55:48.27
676331e2-4477-42c2-a455-9c7b49fabefd	Hindi	2025-05-15 12:55:53.831	2025-05-15 12:55:53.831
86ea0c23-901c-4f1f-a88f-ada725771418	Nepali	2025-05-15 12:56:02.505	2025-05-15 12:56:02.505
05888b8f-8985-4615-807c-7420e9dd6935	Bengali	2025-05-15 12:56:09.127	2025-05-15 12:56:09.127
\.


--
-- Data for Name: Location; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Location" (id, name, "createdAt", "updatedAt", "deliveryApproach", emirate, "locationType", "zoomLink", "backgroundColor", "textColor") FROM stdin;
de111f45-f194-433f-9864-8f6f75cf822e	City Max Hotel	2025-06-16 07:06:54.614	2025-06-17 05:56:53.969	Offline	Sharjah	Rented		#c00ded	#000000
7cee0c69-32f3-4a95-b29b-564dfdb51f09	Al Khayyat Investment (AKI)	2025-06-30 08:55:25.795	2025-07-01 04:31:01.715	Offline	Al Ain	Client		#f0ee13	#000000
fcfee7f1-61a7-4abb-9a0b-09ba3d993439	RMK Al Ain Center 1	2025-06-21 09:03:47.806	2025-07-01 04:31:22.592	Offline	Al Ain	RMK		#e1d91a	#1f3a8a
52025b2e-983a-4d3d-be75-420858d98d67	Almarai Sharjah	2025-06-20 11:18:14.277	2025-06-20 11:18:14.277	Offline	Sharjah	Client	\N	#ed0feb	#000000
defad9f9-3de6-469a-bcd5-9df622c6381a	Abu Dhabi Branch	2025-05-15 12:54:06.853	2025-06-12 08:28:47.047	Offline	Abu Dhabi	RMK		#e78d2f	#000000
c64310d3-1151-4745-a352-083a5a93570f	BSCIC Certification Pvt. Ltd.	2025-06-30 12:30:11.096	2025-07-01 07:15:38.497	Offline	Dubai	Client		#0d16f2	#e0e3eb
06190648-30ec-4215-9aa7-71c0071d1826	Zyypher Test Location	2025-06-21 08:17:03.295	2025-06-21 08:17:03.295	Offline	Sharjah	RMK	\N	#dbeafe	#1f3a8a
4173a3f5-0428-4e4c-a7ab-e4cf8ca58bd3	Sheraton Hotel	2025-05-16 09:01:59.318	2025-07-05 04:41:16.016	Offline	Abu Dhabi	Client		#eb8c0e	#000000
4d0c8215-3911-4f3f-a16e-7e3670daa33a	Almarai Ras Al Khaimah	2025-06-20 11:19:18.504	2025-06-21 12:13:55.457	Offline	Ras Al Khaimah	Client		#0e6dea	#eddfdf
0d384928-b660-455d-abc3-c4536365754d	Kitopi Dubai Head Office	2025-05-16 09:01:31.503	2025-06-12 08:32:37.2	Offline	Dubai	Client		#20ced4	#000000
180a48c3-32d7-406f-85fe-4f48500a6d6a	Almarai Fujairah	2025-06-20 11:19:58.567	2025-06-21 12:16:10.33	Offline	Fujairah	Client		#0d72f5	#ede0e0
12ebb45a-e7e5-413d-8977-62cd86310280	Le Meridien Hotel 	2025-05-16 09:02:14.998	2025-07-05 04:42:21.76	Offline	Abu Dhabi	Client		#eb9a0d	#000000
bf8b5834-e854-4e00-803a-8ae6afa21d0b	Eat & Drink	2025-06-12 08:30:49.349	2025-06-16 07:08:26.432	Offline	Fujairah	Rented		#0fbce7	#000000
230f4eb5-9c00-46be-aa78-6035daeb024b	Bahrain Flour Mills Co. BSC	2025-06-17 04:30:04.134	2025-06-17 04:30:25.547	Offline	Bahrain	Client		#38e20e	#000000
70da7f6e-53ac-4a81-a34d-294ede59b8f1	Al Ain Center	2025-05-15 12:54:37.773	2025-06-17 05:54:13.517	Offline	Al Ain	RMK		#f3e740	#000000
a02db13c-dc7a-4022-acfb-62bfc0502e4a	Hotel Holiday International (HHI)	2025-05-16 08:14:51.112	2025-06-17 05:54:42.474	Offline	Sharjah	Rented		#ea0ec7	#000000
0d51b083-b7fc-43a3-81ab-82f1a3596c47	Radisson Blu Hotel	2025-05-16 09:02:48.899	2025-07-05 04:43:55.545	Offline	Abu Dhabi	Client		#eb780e	#000000
2a722e95-13b3-4924-b46b-7715bb18aefb	Action Hotel 	2025-06-23 05:52:46.118	2025-06-25 04:19:00.799	Offline	Ras Al Khaimah	Rented		#0b66dc	#f5f6fb
a659d3c7-6307-44c6-9e1e-7c2521903ee9	Action Hotel  	2025-05-16 07:58:31.225	2025-06-25 04:19:35.369	Offline	Ras Al Khaimah	Rented		#1079ce	#e8dcdc
913136c0-b58e-4f31-9091-9fb0d2105495	Dubai Head Office	2025-05-13 16:53:46.482	2025-06-25 04:52:28.725	Online	Dubai		http://zoom.us/postattendee?mn=tLBh-Nu4doFNKGLl8kFV1BOoU4h3MUayaOIm.ggeyO-0etvxwbtGg	#40d8f3	#000000
8acc002e-9f21-4b25-a6b2-bcff8a397a77	Dubai Online	2025-06-26 10:10:09.331	2025-06-26 10:10:09.331	Online	Dubai	\N	https://zoom.us/j/94432503897?pwd=GrhrbCNuFYc0x9XigQ4Ic0pDVXO8EO.1	#dbe6ff	#d5daea
a23b6c2b-4517-4ca4-bf51-f1beb24061d5	Farnek Dubai	2025-06-25 06:40:35.497	2025-06-26 10:19:07.989	Offline	Dubai	Client		#0f6bf5	#dbdfeb
ac4f3060-6c9c-4039-be62-442b8e5b0e1f	Al Salama	2025-06-24 04:12:17.69	2025-06-28 09:28:03.601	Offline	Dubai	RMK		#dbdcff	#000000
05e3a99d-c242-427c-88a8-7702a88712e6	Almarai Dubai DIC	2025-06-20 11:18:43.9	2025-07-05 04:46:55.718	Offline	Dubai	Client		#5595e8	#000000
28083cbd-1e26-4018-8139-9ddf5da64624	Almarai Dubai DW	2025-07-05 04:45:31.544	2025-07-05 04:47:13.607	Offline	Dubai	Client		#5592ed	#dce0eb
\.


--
-- Data for Name: PasswordResetToken; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."PasswordResetToken" (id, "userId", token, "expiresAt", "createdAt", "updatedAt") FROM stdin;
5e13d9b7-4108-41d7-90cb-be9fc3962ec8	0e5b8caa-a8e8-40e2-aaec-2bbbd5b67ede	e29cf3ac-687b-41a8-a5e5-b034a3a46ef4	2025-06-11 17:44:54.007	2025-06-11 16:44:54.008	2025-06-11 16:44:54.008
43fb391b-1cfe-41d3-87bb-b5a1e4bb5908	6dc5236f-7d35-4ce5-a860-ef4bdfab80a2	3ac954e7-1326-4226-8e55-95ed12454b13	2025-06-11 17:46:53.283	2025-06-11 16:46:53.284	2025-06-11 16:46:53.284
\.


--
-- Data for Name: Room; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Room" (id, name, capacity, "locationId", notes, "createdAt", "updatedAt") FROM stdin;
903a19f1-5fb1-42f7-8475-50d522495a81	2	15	defad9f9-3de6-469a-bcd5-9df622c6381a		2025-05-16 04:17:20.176	2025-05-16 04:17:20.176
18f1522e-7266-4730-89cc-2033cc2632db	1	15	70da7f6e-53ac-4a81-a34d-294ede59b8f1		2025-05-16 04:17:50.363	2025-05-16 04:17:50.363
f38e7f94-84cd-4609-9790-6b11d7407c6d	1	15	4173a3f5-0428-4e4c-a7ab-e4cf8ca58bd3		2025-07-04 10:26:10.966	2025-07-04 10:32:04.458
3441a485-8338-4c27-90fc-b7dd2bea0c62	2	15	70da7f6e-53ac-4a81-a34d-294ede59b8f1		2025-05-16 04:17:59.49	2025-05-19 17:08:56.768
7c619b6f-6062-4641-9dad-6cfc334a96f0	1	20	28083cbd-1e26-4018-8139-9ddf5da64624		2025-07-05 04:47:45.406	2025-07-05 04:47:45.406
5aaee169-9f72-4594-8f60-cbb04081bfbd	1	15	defad9f9-3de6-469a-bcd5-9df622c6381a		2025-05-16 04:17:04.572	2025-06-10 07:15:41.806
6a1ac52a-3a2e-4652-941a-666691662a62	1	15	0d51b083-b7fc-43a3-81ab-82f1a3596c47	karama branch	2025-05-22 18:09:55.741	2025-06-11 11:02:23.846
2cf380bc-afd2-4727-88aa-0d1f75c78ecc	1	10	de111f45-f194-433f-9864-8f6f75cf822e		2025-06-16 07:15:59.583	2025-06-16 07:15:59.583
cf2fc3e5-3687-4db6-bbad-e7dabdc7b761	3	10	defad9f9-3de6-469a-bcd5-9df622c6381a		2025-05-16 04:17:34.094	2025-06-19 13:05:15.146
7103911f-063f-46c7-b01a-e86d1a4cb765	1	20	05e3a99d-c242-427c-88a8-7702a88712e6		2025-06-20 11:22:06.529	2025-06-20 11:22:06.529
f1dc37b4-1bc4-4d41-8f67-3902f6156ab7	1	20	180a48c3-32d7-406f-85fe-4f48500a6d6a		2025-06-20 11:22:22.248	2025-06-20 11:22:22.248
45cf7aae-99d1-42d0-9087-63ada4864d83	1	20	4d0c8215-3911-4f3f-a16e-7e3670daa33a		2025-06-20 11:22:41.749	2025-06-20 11:22:41.749
8855c5cd-3cd6-4e72-a68e-10dede71c58d	1	15	52025b2e-983a-4d3d-be75-420858d98d67		2025-06-20 11:22:56.589	2025-06-20 11:22:56.589
3a5c78a8-1ab9-4a1e-805c-3457f307d2a1	1	13	a659d3c7-6307-44c6-9e1e-7c2521903ee9		2025-06-23 05:48:30.904	2025-06-23 05:58:00.593
69ba2372-aa15-4a6e-a85e-b62df33b815f	2	20	2a722e95-13b3-4924-b46b-7715bb18aefb		2025-06-23 05:54:02.372	2025-06-23 06:19:09.672
fd214097-4e36-45d7-a273-4d79d054397e	1	20	ac4f3060-6c9c-4039-be62-442b8e5b0e1f		2025-06-24 04:12:38.77	2025-06-24 04:12:38.77
f94ad229-b6e8-43da-ab5b-fd3821ad5166	1	15	a23b6c2b-4517-4ca4-bf51-f1beb24061d5		2025-06-26 10:18:01.884	2025-06-26 10:19:20.75
a01b7e54-90d0-49c6-b3fe-005851f5b51c	1	20	913136c0-b58e-4f31-9091-9fb0d2105495		2025-05-13 16:54:03.025	2025-06-28 04:11:05.853
22d495d0-e1c3-4c25-885d-e81f9b25cd9c	2	20	ac4f3060-6c9c-4039-be62-442b8e5b0e1f		2025-06-28 09:28:43.759	2025-06-28 09:28:43.759
14ff8c3f-5667-412e-9f09-8a3a47276e1c	1	15	7cee0c69-32f3-4a95-b29b-564dfdb51f09	In-house - client facility	2025-06-30 09:17:18.48	2025-06-30 10:27:30.077
396092d2-5674-47a5-a111-44ccb64a6530	3 - Exam Room	15	fcfee7f1-61a7-4abb-9a0b-09ba3d993439		2025-06-30 09:18:47.681	2025-06-30 11:59:30.314
bc34f860-7278-46be-884a-26908f0924e5	1	20	c64310d3-1151-4745-a352-083a5a93570f		2025-06-30 12:30:28.177	2025-06-30 12:30:28.177
eada77d9-c455-4ea3-849b-60873aea5ac7	1	20	8acc002e-9f21-4b25-a6b2-bcff8a397a77		2025-07-01 04:45:54.722	2025-07-01 04:45:54.722
806b93d5-3fbd-4766-8745-f81e24bc63e3	4 - Exam room	15	defad9f9-3de6-469a-bcd5-9df622c6381a		2025-06-18 08:28:35.733	2025-07-03 08:16:52.433
7785aa1e-72d0-4ae8-9bb7-33f14bbe2955	5 - Exam Room	15	defad9f9-3de6-469a-bcd5-9df622c6381a		2025-07-03 08:18:03.601	2025-07-03 08:18:03.601
2e9553eb-f3fe-40b0-9055-f08e46d1b792	1	15	12ebb45a-e7e5-413d-8977-62cd86310280		2025-07-04 10:25:43.772	2025-07-04 10:25:43.772
9ebe33db-86cd-4ac6-a969-2c7c99bc0fd9	1	15	0d51b083-b7fc-43a3-81ab-82f1a3596c47		2025-07-04 10:25:59.321	2025-07-04 10:25:59.321
\.


--
-- Data for Name: Trainer; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Trainer" (id, name, email, phone, "locationId", "availableDays", "timeSlots", "createdAt", "updatedAt", "dailyTimeSlots") FROM stdin;
0ef19354-4e29-4ab4-9515-7ee626e962bc	Prof. Nabil Bashir	ghada@rmktheexperts.com	0588081972	\N	{MON,TUE,WED,THU,FRI,SAT,SUN}	\N	2025-06-16 07:46:58.726	2025-06-16 07:49:01.184	[]
a07a054a-d054-4e14-9bfb-45b5e8bd4f67	Odelon Reyes	odelon.reyes@gmail.com	0508329208	\N	{MON,TUE,WED,THU,FRI,SAT,SUN}	\N	2025-06-16 08:26:37.418	2025-06-16 08:26:37.418	null
1fb61a0f-44c0-4288-a705-bde8d51f93f4	Peter de Guzman	peterdanvert@gmail.com	0588081972	\N	{SUN,MON,TUE,WED,THU,FRI,SAT}	\N	2025-06-16 12:22:54.221	2025-06-16 12:22:54.221	null
09fbabca-cb81-4f58-81ae-4b060edd6bef	Zyypher test	hello@zyypher.com	0554756468	\N	{MON,TUE,WED,THU,FRI}	\N	2025-06-16 15:51:00.372	2025-06-16 15:51:00.372	null
9fccf438-8149-4945-9c86-4e46576472d7	Ramesh Nambiar	ramesh@gmail.com	+971554756469	\N	{MON,TUE,WED,THU,FRI}	\N	2025-05-22 17:36:58.469	2025-05-22 17:36:58.469	[{"end": "2025-05-22T14:00:00.000Z", "start": "2025-05-22T05:00:00.000Z"}]
ef7e72b8-443c-4057-8381-9a489e01af35	Reshmi Unni	reshmiu184@gmail.com	0559986013	\N	{MON,TUE,WED,THU,FRI,SAT,SUN}	\N	2025-06-11 11:00:32.592	2025-06-21 06:52:32.089	[]
eed5630f-3991-4da6-9ffe-a1cabc7afba5	Rachel Salinas	abudhabi@rmktheexperts.com	0529951429	\N	{MON,TUE,WED,THU,FRI,SAT,SUN}	\N	2025-06-21 09:51:13.672	2025-06-21 09:51:13.672	null
d62b351d-25f5-4c3b-b113-b1a0c2ec0cc7	Ann Surya	suryaronnie@gmail.com	0565530980	\N	{MON,TUE,WED,THU,SUN,SAT,FRI}	\N	2025-06-25 06:38:48.824	2025-06-25 06:44:38.323	[]
5327210a-891d-4ad6-a000-d253c474d085	Ali  Zishan	zishan@alsalama.ae	0565114906	\N	{MON,TUE,WED,THU,SUN,SAT,FRI}	\N	2025-06-28 09:32:23.758	2025-06-28 09:32:23.758	null
ac0e715b-6b62-4edf-869d-93c341609999	Mohamed Ibrahim	admin@rmktheexperts.com	0562014730	\N	{MON,TUE,WED,THU,SUN,SAT,FRI}	\N	2025-07-01 05:46:44.883	2025-07-01 05:46:44.883	null
841c652b-c0c9-4b20-9f8a-308169087999	Nithin-BSCIC	admin@rmktheexperts.com	0544450876	\N	{SUN,MON,TUE,WED,THU,SAT,FRI}	\N	2025-07-01 07:13:21.894	2025-07-01 07:13:21.894	null
457b9c23-efb0-4abb-9722-67f602a1d4d8	Remya Ushakumari	remyausha234@yahoo.com	0582451835	\N	{MON,TUE,WED,THU,FRI,SAT,SUN}	\N	2025-06-10 07:19:05.679	2025-06-14 11:33:25.989	[]
574a5211-7cca-48cb-ac8b-d4b8839cd1af	Bijay KC	bijay.kc1982@gmail.com	971553389413	\N	{TUE,WED,THU,MON,FRI,SAT,SUN}	\N	2025-05-13 16:54:31.688	2025-06-14 11:36:49.821	[]
b14ef552-2080-419d-b1dd-d91a49433625	Lalla Toumi	lalla@outlook.com	0554476856	\N	{MON,TUE,WED,THU,FRI,SAT,SUN}	\N	2025-06-12 08:49:22.948	2025-06-16 05:01:13.748	[]
7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	Madhuparna Sengupta	madhuparnasengupta84@gmail.com	971505684090	\N	{MON,TUE,WED,THU,FRI,SAT,SUN}	\N	2025-05-15 13:00:44.523	2025-06-16 06:02:21.021	[]
0939047c-a65e-49f6-a5e2-d18de56bbd01	Fyha Bosati	consultant@rmktheexperts.com	0561500140	\N	{MON,TUE,WED,THU,FRI,SAT,SUN}	\N	2025-06-11 10:57:43.229	2025-06-16 06:02:42.764	[]
\.


--
-- Data for Name: TrainerLeave; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."TrainerLeave" (id, "trainerId", reason, "createdAt", "updatedAt", "endDate", "startDate") FROM stdin;
c4aa957f-0e31-4d0f-b72c-5e16bb5d22ce	574a5211-7cca-48cb-ac8b-d4b8839cd1af		2025-05-19 15:24:21.979	2025-05-19 15:24:21.979	2025-05-21 20:00:00	2025-04-30 20:00:00
277433a2-4a1e-44e5-b7b1-d9793d026a3e	9fccf438-8149-4945-9c86-4e46576472d7		2025-05-26 17:00:57.167	2025-05-26 17:00:57.167	2025-05-30 20:00:00	2025-05-18 20:00:00
e775423f-a53c-4c8e-948f-86c0c2efcfbf	574a5211-7cca-48cb-ac8b-d4b8839cd1af	Pending OFF - April 19, 2025	2025-06-16 12:38:44.241	2025-06-16 12:38:44.241	2025-06-16 20:00:00	2025-06-16 20:00:00
353e0235-62a1-46e4-8fa6-9fb96406e611	457b9c23-efb0-4abb-9722-67f602a1d4d8	Pending OFF - March 21, 2025	2025-06-21 11:13:56.05	2025-06-21 11:13:56.05	2025-06-22 20:00:00	2025-06-22 20:00:00
8722f55e-630a-431b-b1a5-6b2739ccec51	574a5211-7cca-48cb-ac8b-d4b8839cd1af	Replacement off for June 28, 2025	2025-06-28 11:58:33.886	2025-06-28 11:58:33.886	2025-06-29 20:00:00	2025-06-29 20:00:00
\.


--
-- Data for Name: TrainerSchedulingRule; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."TrainerSchedulingRule" (id, "trainerId", "maxSessionsPerDay", "daysOff", "allowOverlap", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: TrainingSession; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."TrainingSession" (id, "courseId", "roomId", date, "startTime", "endTime", "locationId", participants, notes, "selectedSeats", "trainerId", "createdAt", language, "updatedAt") FROM stdin;
548bf8ce-615d-4f03-bdc4-37cb3a825c42	8057479a-6cba-4996-a7f7-52b54f2949be	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-11 20:00:00	2025-07-03 06:00:00	2025-07-03 07:00:00	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Bachir-Eagle Environmental Services & PC-Abu Dhabi branch	[]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-07-03 07:58:24.757	English	2025-07-03 08:20:53.528
cef10dfb-52f5-4074-a66a-cad87fb81b67	29404c10-56eb-4644-9309-6fdeae3e6ad2	a01b7e54-90d0-49c6-b3fe-005851f5b51c	2025-05-14 20:00:00	2025-05-14 12:15:00	2025-05-14 14:30:00	913136c0-b58e-4f31-9091-9fb0d2105495	0		[]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-05-14 16:35:18.5	English	2025-05-14 16:35:18.5
c07a5a1e-58db-4909-9822-c50dd1dee311	cf9c2fba-baf9-441e-a72a-dc7c1939683d	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-05-19 20:00:00	2025-05-16 05:00:00.689	2025-05-16 12:00:00.888	0d384928-b660-455d-abc3-c4536365754d	2		["S1", "S2"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-05-16 09:35:58.853	English	2025-05-16 09:35:58.853
18e4874a-b9a1-445b-91cd-09a089b12300	0542daa1-3922-4e3c-b592-2837e583f1ed	a01b7e54-90d0-49c6-b3fe-005851f5b51c	2025-05-15 20:00:00	2025-05-16 19:30:00.435	2025-05-16 19:45:00.612	913136c0-b58e-4f31-9091-9fb0d2105495	0		[]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-05-16 19:58:53.357	Nepali	2025-05-16 19:58:53.357
22aaaf2f-8448-4c70-bc92-88c0857ef0fa	71c6f1e5-0fb5-4140-a0c4-3968493391b8	cf2fc3e5-3687-4db6-bbad-e7dabdc7b761	2025-09-19 20:00:00	2025-05-21 17:30:00	2025-05-21 19:45:00	defad9f9-3de6-469a-bcd5-9df622c6381a	1	new with client	["S6"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-05-21 15:51:49.6	Malayalam	2025-05-21 15:51:49.6
3524eeee-7965-4765-b3f3-a60d3d5377dd	2ea7bb56-6dc5-4e0c-bb23-16169ff07760	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-05-23 20:00:00	2025-05-21 04:00:00.263	2025-05-21 13:00:00.779	defad9f9-3de6-469a-bcd5-9df622c6381a	1	hello 	["S1"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-05-21 18:27:47.743	English	2025-05-21 18:27:47.743
2df85f5b-887e-475a-8603-896444d13999	3d1b1703-2450-4ff1-9cee-2ad320d63959	6a1ac52a-3a2e-4652-941a-666691662a62	2025-04-27 20:00:00	2025-05-23 09:30:00.115	2025-05-23 11:15:00.22	0d51b083-b7fc-43a3-81ab-82f1a3596c47	4		["S1", "S2", "S3", "S4"]	9fccf438-8149-4945-9c86-4e46576472d7	2025-05-23 16:01:11.836	Malayalam	2025-05-26 16:52:09.343
dc337a31-f605-4c7e-bac8-4ab7bd3e8a95	6b92a3b0-f5b2-4ec3-a9ae-9a1a05a58989	6a1ac52a-3a2e-4652-941a-666691662a62	2025-06-10 20:00:00	2025-06-10 18:00:00.328	2025-06-10 19:15:00.767	0d51b083-b7fc-43a3-81ab-82f1a3596c47	1	test1	["S1"]	9fccf438-8149-4945-9c86-4e46576472d7	2025-06-10 18:36:51.447	Bengali	2025-06-10 19:31:08.594
dedcda77-5403-4631-be6c-111b66c03983	d7dc0686-718a-491f-92c4-6bfb7745b8bc	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-06-10 20:00:00	2025-06-10 05:00:00.368	2025-06-10 12:00:00.208	defad9f9-3de6-469a-bcd5-9df622c6381a	2		["S5", "S1"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-10 07:26:38.663	English	2025-06-10 07:26:38.663
bc2cdee9-202b-4ac4-a812-10222662d5e1	6b92a3b0-f5b2-4ec3-a9ae-9a1a05a58989	18f1522e-7266-4730-89cc-2033cc2632db	2025-06-10 20:00:00	2025-06-10 05:00:00.704	2025-06-10 12:00:00.272	70da7f6e-53ac-4a81-a34d-294ede59b8f1	2	Aishwarya will sit	["S1", "S2"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-10 07:34:34.541	Malayalam	2025-06-10 19:42:20.49
b1c262d0-2032-4a8f-b1f1-b78ea132e68e	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-06-11 20:00:00	2025-06-12 05:00:00.686	2025-06-12 12:00:00.454	defad9f9-3de6-469a-bcd5-9df622c6381a	1		["S1"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-12 10:48:25.071	Hindi	2025-06-14 07:40:24.343
dd94df69-7cc9-40e4-9196-3f2d472eb1c6	0542daa1-3922-4e3c-b592-2837e583f1ed	3441a485-8338-4c27-90fc-b7dd2bea0c62	2025-06-15 20:00:00	2025-06-14 05:00:00.99	2025-06-14 12:00:00.662	70da7f6e-53ac-4a81-a34d-294ede59b8f1	10		["S2", "S3", "S4", "S5", "S6", "S12", "S7", "S8", "S10", "S9"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-14 11:37:29.807	Hindi	2025-06-23 06:46:36.53
218c24c5-a4de-428f-a773-3420d2431590	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-06-13 20:00:00	2025-06-14 05:00:00.454	2025-06-14 12:00:00.373	defad9f9-3de6-469a-bcd5-9df622c6381a	0		[]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-14 08:37:49.626	English	2025-06-14 08:37:49.626
4fd45c2f-9e91-43f6-8f23-c4e9477f41cf	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-06-13 20:00:00	2025-06-14 05:00:00.454	2025-06-14 12:00:00.373	defad9f9-3de6-469a-bcd5-9df622c6381a	0		[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-14 08:38:17.394	Malayalam	2025-06-14 08:38:17.394
98cffd83-ea3d-45d9-989f-c05384afe39c	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-06-11 20:00:00	2025-06-12 05:00:00.311	2025-06-12 12:00:00.654	70da7f6e-53ac-4a81-a34d-294ede59b8f1	0		[]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-12 10:49:30.306	English	2025-06-12 10:49:30.306
25bfeac2-5963-4f23-a061-c6b14537f412	29404c10-56eb-4644-9309-6fdeae3e6ad2	903a19f1-5fb1-42f7-8475-50d522495a81	2025-06-15 20:00:00	2025-06-16 05:00:00.376	2025-06-16 12:00:00.008	defad9f9-3de6-469a-bcd5-9df622c6381a	0		[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-16 06:04:49.506	Malayalam	2025-06-16 10:36:13.82
c89c96a5-87f1-41bd-b33f-8f3eafdbc22f	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-06-13 20:00:00	2025-06-14 05:00:00.454	2025-06-14 12:00:00.373	70da7f6e-53ac-4a81-a34d-294ede59b8f1	0		[]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-14 08:38:41.909	English	2025-06-14 08:38:41.909
3fd2a0f5-e0ac-449a-a379-69ff747f6430	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-06-11 20:00:00	2025-06-12 05:00:00.501	2025-06-12 12:00:00.693	defad9f9-3de6-469a-bcd5-9df622c6381a	5		["S1", "S2", "S3", "S5", "S6"]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-12 10:29:18.537	English	2025-06-16 06:12:52.402
3edf25c5-db8b-4ffc-a26e-1408b20a072e	29404c10-56eb-4644-9309-6fdeae3e6ad2	903a19f1-5fb1-42f7-8475-50d522495a81	2025-06-16 20:00:00	2025-06-16 05:00:00	2025-06-16 12:00:00	defad9f9-3de6-469a-bcd5-9df622c6381a	0		[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-16 12:16:48.3	English	2025-06-17 08:41:56.773
94427a80-8b8c-4b4b-921e-82cd114b73fd	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-06-15 20:00:00	2025-06-16 05:00:00.376	2025-06-16 12:00:00.008	defad9f9-3de6-469a-bcd5-9df622c6381a	0		[]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-16 06:04:15.524	English	2025-06-16 10:40:07.193
bcdf72e1-cb45-4994-bdb2-c0878fcc5ecf	29404c10-56eb-4644-9309-6fdeae3e6ad2	18f1522e-7266-4730-89cc-2033cc2632db	2025-06-15 20:00:00	2025-06-14 05:00:00.831	2025-06-14 10:00:00	70da7f6e-53ac-4a81-a34d-294ede59b8f1	5	have delegates	["S8", "S9", "S3", "S4", "S1"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-14 11:34:40.837	Malayalam	2025-06-16 17:52:36.497
5f52f509-bb57-41a9-ab6d-16e86933f8c7	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-06-16 20:00:00	2025-06-16 05:00:00	2025-06-16 12:00:00	defad9f9-3de6-469a-bcd5-9df622c6381a	1		["S1"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-16 12:16:16.41	English	2025-06-17 07:27:55.649
bec3c6f9-2b6a-4809-9b40-da24eda24376	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-06-16 20:00:00	2025-06-16 05:00:00	2025-06-16 12:00:00	70da7f6e-53ac-4a81-a34d-294ede59b8f1	1		["S1"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-16 12:11:20.883	Malayalam	2025-06-18 05:27:23.261
fd5cc5be-5841-4a61-990b-748044281992	29404c10-56eb-4644-9309-6fdeae3e6ad2	3441a485-8338-4c27-90fc-b7dd2bea0c62	2025-06-16 20:00:00	2025-06-16 05:00:00	2025-06-16 12:00:00	70da7f6e-53ac-4a81-a34d-294ede59b8f1	3		["S7", "S3", "S9"]	b14ef552-2080-419d-b1dd-d91a49433625	2025-06-16 12:11:55.125	Arabic	2025-06-17 10:00:09.629
07c11140-b7c6-4009-806b-ee7c97a3cad3	0542daa1-3922-4e3c-b592-2837e583f1ed	3441a485-8338-4c27-90fc-b7dd2bea0c62	2025-06-11 20:00:00	2025-06-12 05:00:00.311	2025-06-12 12:00:00.654	70da7f6e-53ac-4a81-a34d-294ede59b8f1	3		["S5", "S2", "S3"]	b14ef552-2080-419d-b1dd-d91a49433625	2025-06-12 10:49:50.97	Arabic	2025-06-19 13:21:47.732
e38fa1a5-1232-4b9d-bcbc-3f858b4e5a17	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-07-16 20:00:00	2025-07-01 05:00:00.473	2025-07-01 12:00:00	70da7f6e-53ac-4a81-a34d-294ede59b8f1	7	Raquel-Int'l Grandmart-4C	["S1", "S2", "S5", "S6", "S10", "S13", "S14"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-07-01 10:31:30.178	English	2025-07-04 10:15:05.328
786f272a-16a8-4d57-9699-187f10029c92	e0f45b2f-55e7-4a6f-a65f-d3d9c9409372	2cf380bc-afd2-4727-88aa-0d1f75c78ecc	2025-06-15 20:00:00	2025-06-17 05:00:00.84	2025-06-17 12:00:00.12	de111f45-f194-433f-9864-8f6f75cf822e	2		["S2", "S1"]	0ef19354-4e29-4ab4-9515-7ee626e962bc	2025-06-17 04:34:57.37	English	2025-06-17 04:48:43.023
9de92126-1e2c-43f1-b6fc-e0153b41edc5	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-06-17 20:00:00	2025-06-17 05:00:00	2025-06-17 12:00:00	defad9f9-3de6-469a-bcd5-9df622c6381a	0		[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-17 13:22:31.946	English	2025-06-17 13:23:30.832
1ed26bb5-f808-41f8-bec3-6817e154604e	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-06-18 20:00:00	2025-06-19 05:00:00.768	2025-06-19 12:00:00.159	defad9f9-3de6-469a-bcd5-9df622c6381a	1		["S1"]	b14ef552-2080-419d-b1dd-d91a49433625	2025-06-19 04:35:11.859	Arabic	2025-06-19 09:49:33.457
6dc64863-5b95-4ae8-997c-412fabbd2e3b	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-06-19 20:00:00	2025-06-20 05:00:00.403	2025-06-20 12:00:00.867	70da7f6e-53ac-4a81-a34d-294ede59b8f1	7		["S6", "S3", "S7", "S8", "S10", "S12", "S1"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-20 05:45:28.619	English	2025-06-20 11:00:36.734
5a789dc5-ce40-4fe6-b4bf-b7bbe5c0da33	29404c10-56eb-4644-9309-6fdeae3e6ad2	3441a485-8338-4c27-90fc-b7dd2bea0c62	2025-06-30 20:00:00	2025-06-18 05:00:00.05	2025-06-18 09:30:00	70da7f6e-53ac-4a81-a34d-294ede59b8f1	5		["S7", "S5", "S6", "S3", "S4"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-18 07:06:10.594	Hindi	2025-07-02 06:51:45.429
94c4649d-436b-40bc-b6b3-f41059f83d20	29404c10-56eb-4644-9309-6fdeae3e6ad2	cf2fc3e5-3687-4db6-bbad-e7dabdc7b761	2025-06-18 20:00:00	2025-06-19 05:00:00.768	2025-06-19 09:30:00	defad9f9-3de6-469a-bcd5-9df622c6381a	2		["S3", "S4"]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-19 04:35:52.404	Malayalam	2025-06-19 12:44:46.724
054a4a46-dcbc-4887-b967-b22c901d732a	3be29657-6775-40e1-b04b-96d7d70205d4	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-06-18 20:00:00	2025-06-19 17:45:00.499	2025-06-19 19:00:00.589	defad9f9-3de6-469a-bcd5-9df622c6381a	0	zyypher testing	[]	09fbabca-cb81-4f58-81ae-4b060edd6bef	2025-06-19 17:09:53.637	English	2025-06-19 17:09:53.637
cae29138-7cc5-4834-9d84-eee3f7a7d70a	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-06-30 20:00:00	2025-06-18 05:00:00.05	2025-06-18 12:00:00.945	70da7f6e-53ac-4a81-a34d-294ede59b8f1	7		["S9", "S10", "S3", "S8", "S4", "S5", "S11"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-18 07:04:59.198	Malayalam	2025-07-02 06:51:30.361
6a3e726b-9edc-4e9e-8280-b94f0d3b56e1	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-06-19 20:00:00	2025-06-20 05:00:00	2025-06-20 12:00:00	defad9f9-3de6-469a-bcd5-9df622c6381a	0		[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-20 05:32:01.303	Malayalam	2025-06-20 05:32:01.303
d8c65465-c065-4390-bb6d-3d0b848196d4	29404c10-56eb-4644-9309-6fdeae3e6ad2	18f1522e-7266-4730-89cc-2033cc2632db	2025-06-17 20:00:00	2025-06-17 05:00:00.022	2025-06-17 09:30:00	70da7f6e-53ac-4a81-a34d-294ede59b8f1	3		["S9", "S8", "S1"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-17 13:25:55.732	Hindi	2025-06-18 09:25:29.708
2467666f-e294-4e89-bfab-fdb4d39727f9	0542daa1-3922-4e3c-b592-2837e583f1ed	3441a485-8338-4c27-90fc-b7dd2bea0c62	2025-07-13 20:00:00	2025-07-01 05:00:00.473	2025-07-01 12:00:00	70da7f6e-53ac-4a81-a34d-294ede59b8f1	1	Raquel-Int'l Grandmart-4C	["S6"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-07-01 10:30:11.737	English	2025-07-04 10:00:10.244
9ef74971-3796-48b1-8baa-f875a2138999	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-06-17 20:00:00	2025-06-17 05:00:00.494	2025-06-17 12:00:00.55	defad9f9-3de6-469a-bcd5-9df622c6381a	1		["S1"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-17 13:24:19.363	Hindi	2025-06-18 09:30:15.824
fd8e926d-fe3d-47d7-b49c-2252cdeb93a6	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-06-23 20:00:00	2025-06-21 05:00:00.117	2025-06-21 12:00:00.62	defad9f9-3de6-469a-bcd5-9df622c6381a	6	McDonalds	["S9", "S1", "S7", "S2", "S11", "S13"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-21 07:01:54.568	English	2025-06-24 06:12:35.241
2506ee8e-1255-4be5-bc3f-26800da832b5	29404c10-56eb-4644-9309-6fdeae3e6ad2	3441a485-8338-4c27-90fc-b7dd2bea0c62	2025-06-17 20:00:00	2025-06-17 05:00:00.749	2025-06-17 09:30:00	70da7f6e-53ac-4a81-a34d-294ede59b8f1	2		["S3", "S2"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-17 13:31:10.191	English	2025-06-18 09:30:30.669
7fc927e7-65a8-4aa6-a12b-158af55bce5f	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-07-22 20:00:00	2025-07-01 05:00:00.473	2025-07-01 12:00:00	70da7f6e-53ac-4a81-a34d-294ede59b8f1	5	Raquel-Int'l Grandmart-4C	["S1", "S2", "S3", "S4", "S9"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-07-01 10:32:18.078	English	2025-07-04 10:07:20.903
6bf1984a-a489-486c-8f0a-07fa39412c2f	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-06-18 20:00:00	2025-06-19 05:00:00.768	2025-06-19 12:00:00.159	defad9f9-3de6-469a-bcd5-9df622c6381a	1		["S1"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-19 04:34:27.414	English	2025-06-19 04:42:46.811
39c0f7d2-4cf0-4d98-9ce6-d96c1131a522	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-07-20 20:00:00	2025-07-03 05:00:00.433	2025-07-03 12:00:00.584	70da7f6e-53ac-4a81-a34d-294ede59b8f1	1	c/o Abhi	["S3"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-07-03 07:10:20.134	English	2025-07-04 10:10:37.592
6c9e7df1-1912-401d-b067-2fbcb30bf771	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-06-22 20:00:00	2025-06-21 05:00:00.845	2025-06-21 12:00:00.789	70da7f6e-53ac-4a81-a34d-294ede59b8f1	5		["S10", "S9", "S5", "S1", "S2"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-21 06:55:03.348	English	2025-06-23 10:02:51.583
48f9537e-2c16-47ae-9582-98182781c812	db9d765a-79b1-404c-b83d-9398dcd097fb	3441a485-8338-4c27-90fc-b7dd2bea0c62	2025-06-19 20:00:00	2025-06-20 05:00:00.403	2025-06-20 12:00:00.867	70da7f6e-53ac-4a81-a34d-294ede59b8f1	2		["S4", "S3"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-20 05:46:02.972	English	2025-06-20 11:03:36.918
2d623868-3c7e-4603-8fb0-3b057d9aecd3	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-06-19 20:00:00	2025-06-20 05:00:00	2025-06-20 12:00:00	defad9f9-3de6-469a-bcd5-9df622c6381a	4		["S3", "S4", "S1", "S2"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-20 05:32:33.728	English	2025-06-20 12:44:36.211
0c6de82d-4d6c-47cd-aa90-7cfa1ffe9992	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-06-22 20:00:00	2025-06-21 05:00:00.862	2025-06-21 12:00:00.645	defad9f9-3de6-469a-bcd5-9df622c6381a	10	Hala-Khalidiya-8C \nJosephine -Fassco-6C	["S1", "S2", "S4", "S5", "S7", "S8", "S9", "S10", "S13", "S14"]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-21 06:50:07.127	English	2025-06-21 08:11:34.208
3fc70cfb-9bcf-43c7-a229-6102fce06a3e	0542daa1-3922-4e3c-b592-2837e583f1ed	3441a485-8338-4c27-90fc-b7dd2bea0c62	2025-06-22 20:00:00	2025-06-21 05:00:00.845	2025-06-21 12:00:00.789	70da7f6e-53ac-4a81-a34d-294ede59b8f1	3		["S7", "S2", "S3"]	b14ef552-2080-419d-b1dd-d91a49433625	2025-06-21 06:55:19.355	Arabic	2025-06-23 10:08:53.242
9dd3e330-a2fb-4d12-8eaf-9f0fde878e1d	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-14 20:00:00	2025-07-02 05:00:00.544	2025-07-02 12:00:00.615	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Abdullah-Side Hustle (QRM)-5tbc / Athira Caffeino 7tbc	[]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-07-02 06:38:25.981	English	2025-07-04 12:40:47.964
20e47a77-921d-4910-b741-283f35f1781c	0542daa1-3922-4e3c-b592-2837e583f1ed	3441a485-8338-4c27-90fc-b7dd2bea0c62	2025-06-23 20:00:00	2025-06-21 05:00:00.523	2025-06-21 12:00:00.962	70da7f6e-53ac-4a81-a34d-294ede59b8f1	3		["S2", "S5", "S6"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-21 07:22:16.123	Hindi	2025-06-24 06:29:11.418
a6fbafb8-1171-46e5-ae8c-c08d1a641971	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-06-23 20:00:00	2025-06-21 05:00:00.063	2025-06-21 12:00:00.887	defad9f9-3de6-469a-bcd5-9df622c6381a	6	Ibrahim-Kitopi-4C \nArun-Fassco-3C \nNabeel Cravia-4tbc	["S4", "S10", "S11", "S13", "S12", "S14"]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-21 06:34:27.16	English	2025-06-24 07:51:59.954
04c55980-d280-407c-a641-9171794c50f1	1aab3af3-6afc-463d-8ed2-eaeff7dd4510	cf2fc3e5-3687-4db6-bbad-e7dabdc7b761	2025-06-22 20:00:00	2025-06-21 05:00:00.819	2025-06-21 13:00:00.363	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Personal Training	[]	0939047c-a65e-49f6-a5e2-d18de56bbd01	2025-06-21 08:35:16.997	Arabic	2025-06-21 08:35:35.611
0555bacb-0d59-47b9-8489-086678a6abd9	d7dc0686-718a-491f-92c4-6bfb7745b8bc	f1dc37b4-1bc4-4d41-8f67-3902f6156ab7	2025-07-03 20:00:00	2025-06-21 09:00:00	2025-06-21 15:00:00	180a48c3-32d7-406f-85fe-4f48500a6d6a	1	In-house	["S1"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-21 12:15:47.254	English	2025-07-03 06:47:06.815
5bca0cf0-431a-4302-b552-e06e16182b67	8057479a-6cba-4996-a7f7-52b54f2949be	806b93d5-3fbd-4766-8745-f81e24bc63e3	2025-06-25 20:00:00	2025-06-21 10:00:00.044	2025-06-21 11:00:00.844	defad9f9-3de6-469a-bcd5-9df622c6381a	1		["S2"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-21 09:52:13.295	English	2025-06-25 11:57:44.262
b31603a5-c3b1-4634-ab59-7991d472803f	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-06-24 20:00:00	2025-06-21 05:00:00.731	2025-06-21 12:00:00.971	70da7f6e-53ac-4a81-a34d-294ede59b8f1	5	Biverly-LaBrioche-tbc,confirmed -10	["S3", "S1", "S2", "S5", "S6"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-21 08:39:59.071	English	2025-06-25 06:00:28.615
10d349ca-7c77-476d-94ad-61ce1d0da530	4b7bbda3-36c9-4dab-bd83-89cc973eef60	806b93d5-3fbd-4766-8745-f81e24bc63e3	2025-07-04 20:00:00	2025-07-04 09:00:00.025	2025-07-04 10:00:00.009	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Bachir-PC Supervisor-2C-RMK Abu Dhabi (Re-exam)	[]	eed5630f-3991-4da6-9ffe-a1cabc7afba5	2025-07-04 06:29:56.106	English	2025-07-05 07:42:03.898
ae065564-1ddd-42ad-b7b7-e8f8af30568b	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-07-02 20:00:00	2025-06-21 05:00:00.887	2025-06-21 12:00:00.911	defad9f9-3de6-469a-bcd5-9df622c6381a	4	McDonalds	["S9", "S10", "S11", "S3"]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-21 10:49:15.311	English	2025-07-03 08:16:12.238
1c36399f-ffcb-4b3d-8f2c-34fa94bf7700	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-06-29 20:00:00	2025-06-21 05:00:00.889	2025-06-21 12:00:00.889	defad9f9-3de6-469a-bcd5-9df622c6381a	9	Jennifer-Pearl Rotana-5C / Mira-Accor Novotel-1C / Jerson-Fiesta Ave-2tbc/Hala-3C	["S4", "S10", "S11", "S12", "S14", "S2", "S7", "S8", "S1"]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-21 10:18:45.566	English	2025-06-30 09:05:01.814
f03f9394-e306-49e9-aac3-6473745aad38	29404c10-56eb-4644-9309-6fdeae3e6ad2	903a19f1-5fb1-42f7-8475-50d522495a81	2025-06-25 20:00:00	2025-06-21 05:00:00.058	2025-06-21 09:30:00	defad9f9-3de6-469a-bcd5-9df622c6381a	5	Abdul-Patchi-1C	["S2", "S6", "S1", "S3", "S4"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-21 10:15:37.51	English	2025-06-26 05:01:19.487
e10222f4-a1e4-43e0-8dd2-2cb29a2157bc	29404c10-56eb-4644-9309-6fdeae3e6ad2	806b93d5-3fbd-4766-8745-f81e24bc63e3	2025-07-07 20:00:00	2025-06-21 05:00:00.121	2025-06-21 09:30:00.136	defad9f9-3de6-469a-bcd5-9df622c6381a	5	Arshad-Patchi-3C / Rashad-Almaya-1C\nModern Mood Gen Trading c/o cacao 2 pax \n2 your destination 3 tinoh  c	["S2", "S4", "S5", "S7", "S10"]	b14ef552-2080-419d-b1dd-d91a49433625	2025-06-21 11:53:13.207	Arabic	2025-07-04 08:44:19.884
a3f8a171-6fea-4c4d-adab-174a2b1b55c7	1e88e10b-95f1-4b8e-9cfe-8b8a381a336d	cf2fc3e5-3687-4db6-bbad-e7dabdc7b761	2025-06-25 20:00:00	2025-06-21 05:00:00.453	2025-06-21 10:00:00.685	defad9f9-3de6-469a-bcd5-9df622c6381a	1		["S1"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-21 09:38:26.825	English	2025-06-25 11:56:29.116
59c3331b-5cad-4236-a72e-1a3b6547128f	29404c10-56eb-4644-9309-6fdeae3e6ad2	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-06-30 20:00:00	2025-06-21 05:00:00.841	2025-06-21 12:00:00.529	defad9f9-3de6-469a-bcd5-9df622c6381a	8	c/o Rachel	["S3", "S12", "S13", "S14", "S15", "S11", "S6", "S5"]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-21 10:25:26.71	Malayalam	2025-07-01 08:17:45.997
a92bce94-c67f-4943-b247-90103ede8f04	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-06-29 20:00:00	2025-06-21 05:00:00.937	2025-06-21 12:00:00.426	70da7f6e-53ac-4a81-a34d-294ede59b8f1	6	CONFIRMED-10,NOT CONFIRMED-3,REVISION-2	["S13", "S14", "S5", "S6", "S7", "S10"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-21 10:23:02.93	English	2025-06-30 06:13:37.968
c003f4af-41ce-4fc7-b59e-d3c450556897	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-06-22 20:00:00	2025-06-21 05:00:00.319	2025-06-21 12:00:00.958	defad9f9-3de6-469a-bcd5-9df622c6381a	5	McDonalds-15C	["S11", "S2", "S3", "S5", "S10"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-21 06:40:02.206	English	2025-06-23 07:54:52.802
75b83c82-3c2a-4e69-88c8-55d3a7faa4cb	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-06-25 20:00:00	2025-06-21 05:00:00.058	2025-06-21 12:00:00.858	defad9f9-3de6-469a-bcd5-9df622c6381a	8	McDonalds	["S13", "S12", "S11", "S4", "S3", "S7", "S1", "S2"]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-21 10:15:05.942	English	2025-06-26 12:01:26.031
7f271b9d-818b-472d-b5e2-fc9d5a1de59e	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-06-24 20:00:00	2025-06-21 05:00:00.723	2025-06-21 12:00:00.819	defad9f9-3de6-469a-bcd5-9df622c6381a	8	C/O Rachel - Full	["S3", "S7", "S8", "S9", "S1", "S10", "S12", "S5"]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-21 08:43:33.865	English	2025-06-25 10:43:45.042
57f2b101-ffb6-4649-a03a-74e73e1cf855	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-06-25 20:00:00	2025-06-21 05:00:00.217	2025-06-21 12:00:00.058	70da7f6e-53ac-4a81-a34d-294ede59b8f1	5	13 confirmed / Divesh-Grandiose-1C / 2 revision	["S10", "S12", "S1", "S2", "S9"]	b14ef552-2080-419d-b1dd-d91a49433625	2025-06-21 10:16:11.259	Arabic	2025-06-26 06:02:38.586
51421efe-addf-44bc-930a-15e84da4a314	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-06-24 20:00:00	2025-06-21 05:00:00.779	2025-06-21 12:00:00.403	defad9f9-3de6-469a-bcd5-9df622c6381a	9	McDonalds-15	["S5", "S4", "S14", "S11", "S8", "S15", "S10", "S12", "S1"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-21 08:41:56.859	English	2025-06-25 11:56:11.756
1c37c6b7-3b0c-4778-ace3-b4b034cff06b	29404c10-56eb-4644-9309-6fdeae3e6ad2	3441a485-8338-4c27-90fc-b7dd2bea0c62	2025-06-24 20:00:00	2025-06-21 05:00:00.731	2025-06-21 12:00:00.971	70da7f6e-53ac-4a81-a34d-294ede59b8f1	8	confirmed-10	["S3", "S4", "S5", "S6", "S7", "S8", "S9", "S10"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-21 08:40:26.295	Malayalam	2025-06-25 06:12:22.29
8d1824c5-41ae-4261-a9e5-46cd3d6f1913	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-06-29 20:00:00	2025-06-21 05:00:00.297	2025-06-21 12:00:00	defad9f9-3de6-469a-bcd5-9df622c6381a	3	C/O Rachel\n6 pX 	["S3", "S2", "S6"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-21 10:20:35.146	Hindi	2025-06-30 11:08:01.833
e282861b-facd-43b2-b6ba-238dc83e9f9c	a627bd22-2dbe-47d9-aaf1-309ec1ea9eba	45cf7aae-99d1-42d0-9087-63ada4864d83	2025-07-03 20:00:00	2025-06-21 05:00:00.615	2025-06-21 11:00:00.374	4d0c8215-3911-4f3f-a16e-7e3670daa33a	0	Inhouse	[]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-21 12:13:00.743	English	2025-06-21 12:13:23.566
c9f469ad-5c2e-4e72-80c8-31f8de8443a3	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-27 20:00:00	2025-07-03 05:00:00.013	2025-07-03 12:00:00.766	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Josephine FASSCO Danat 3tbc	[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-07-03 12:45:31.946	English	2025-07-03 12:47:19.198
01ac10eb-541a-4191-818e-f99b5b3f65bc	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-09 20:00:00	2025-06-23 05:00:00.527	2025-06-23 12:00:00.151	defad9f9-3de6-469a-bcd5-9df622c6381a	0	true boutique 2 / Reshma-tbc / Abdulla-Pizza De Rocco-5tbc / panaderia  1 mirrage marine 1\nFULL\n	[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-23 08:11:19.119	English	2025-07-05 10:25:38.38
eb43d95b-efd3-479e-9fa8-159ed73fa2ee	8057479a-6cba-4996-a7f7-52b54f2949be	903a19f1-5fb1-42f7-8475-50d522495a81	2025-07-11 20:00:00	2025-07-03 06:00:00	2025-07-03 07:00:00	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Bachir-Eagle Environmental Services & PC-Abu Dhabi branch-11 C	[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-07-03 07:58:48.97	English	2025-07-03 08:20:12.81
243d1662-48a7-46bc-8e98-eea5e4a2ca9f	8057479a-6cba-4996-a7f7-52b54f2949be	cf2fc3e5-3687-4db6-bbad-e7dabdc7b761	2025-07-11 20:00:00	2025-07-03 08:00:00	2025-07-03 09:00:00.825	defad9f9-3de6-469a-bcd5-9df622c6381a	0		[]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-07-03 08:22:15.934	English	2025-07-03 08:22:15.934
175c8a29-edfc-4d13-9b6b-c4ae7485443e	471a65f6-e385-499a-9846-8d0157da3274	a01b7e54-90d0-49c6-b3fe-005851f5b51c	2025-07-03 20:00:00	2025-06-26 09:00:00	2025-06-26 14:00:00	913136c0-b58e-4f31-9091-9fb0d2105495	0	Hanfred-2C-WTCD Technician - Online via Zoom - Ann Surya will attend the session	[]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-26 10:07:48.64	English	2025-07-03 08:27:13.02
a2177366-e7da-40ec-a107-634a590c59c1	8057479a-6cba-4996-a7f7-52b54f2949be	806b93d5-3fbd-4766-8745-f81e24bc63e3	2025-07-11 20:00:00	2025-07-03 08:00:00	2025-07-03 09:00:00.825	defad9f9-3de6-469a-bcd5-9df622c6381a	0		[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-07-03 08:22:43.924	English	2025-07-03 08:43:30.442
bdf8617b-596e-4071-ac63-8a2e5116f55f	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-02 20:00:00	2025-06-21 05:00:00.887	2025-06-21 12:00:00.911	defad9f9-3de6-469a-bcd5-9df622c6381a	9	Nabeel-Cravia-4C / Menly Bounce-2C /   1 personal  / 1 gotohan / 1   / 1 tanzeem / 2 btwn rest\nFULL    bedahisng beauty 1  marlon	["S13", "S6", "S12", "S1", "S2", "S3", "S4", "S8", "S10"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-21 10:49:00.807	English	2025-07-03 10:42:16.983
527901d2-cbca-4eff-b810-349d62be9972	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-30 20:00:00	2025-07-04 05:00:00.609	2025-07-04 12:00:00.217	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Josephine FASSCO Danat 3tbc	[]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-07-04 05:10:10.335	English	2025-07-04 05:14:34.085
6824e9de-19c5-40a3-8dae-bf47f983c486	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-03 20:00:00	2025-06-25 05:00:00.38	2025-06-25 12:00:00.148	defad9f9-3de6-469a-bcd5-9df622c6381a	9	c/o Rachel/Farsana- 11 for farsana\ngoto han 1\nbtwn restv 1	["S1", "S2", "S4", "S5", "S6", "S7", "S8", "S11", "S12"]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-25 11:53:50.586	English	2025-07-04 08:02:48.2
6e95257b-127a-4e5b-b68d-1d789339f69d	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-06 20:00:00	2025-06-23 05:00:00.733	2025-06-23 12:00:00.268	defad9f9-3de6-469a-bcd5-9df622c6381a	8	Menly-Bounce-6C / Mira-Accor-1tbc / cevapi house 4\nFull for rachel  / 2 ground cafe 	["S9", "S1", "S2", "S3", "S4", "S5", "S6", "S12"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-23 04:31:54.056	English	2025-07-05 11:30:41.097
02c5fd65-7946-4dcb-ae92-1b8e630492b7	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-20 20:00:00	2025-07-03 05:00:00.07	2025-07-03 12:00:00.35	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Josephine FASSCO Danat 3tbc / Abdullah Side Hustle 5tbc	[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-07-03 12:43:39.352	English	2025-07-04 11:43:44.271
cf56b5dc-8995-4631-87b5-cce1179d70f2	29404c10-56eb-4644-9309-6fdeae3e6ad2	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-08-14 20:00:00	2025-06-24 05:00:00.987	2025-06-24 09:30:00.146	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Shihab-Almarai Abu Dhabi	[]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-24 04:21:01.789	English	2025-06-24 04:22:30.478
41bf13ff-1c76-4283-9546-465918ef71bd	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-07-06 20:00:00	2025-06-24 05:00:00.781	2025-06-24 12:00:00.957	70da7f6e-53ac-4a81-a34d-294ede59b8f1	9	catering english ,confirmed -13,revision-1	["S6", "S7", "S8", "S2", "S3", "S5", "S14", "S12", "S10"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-24 10:53:57.723	English	2025-07-05 11:08:26.099
5918dbf2-a767-4c9c-9f4f-af77823f1be4	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-07 20:00:00	2025-06-23 05:00:00.527	2025-06-23 12:00:00.151	defad9f9-3de6-469a-bcd5-9df622c6381a	5	c/o Rachel\n6 mcdonalds  tru boutique 2 hot pot \nfull rachel .. lowela u are not allowed to put anything 	["S1", "S3", "S4", "S5", "S6"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-23 08:10:00.693	English	2025-07-04 11:32:29.561
085d0bb3-372d-416d-a060-611751bc1a7d	29404c10-56eb-4644-9309-6fdeae3e6ad2	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-08-07 20:00:00	2025-06-24 05:00:00.378	2025-06-24 09:30:00.514	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Shihab-Almarai Abu Dhabi	[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-24 04:29:21.663	English	2025-06-24 04:33:33.428
2c25d1dc-2043-40df-95ff-eaf843fdd6fb	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-06-30 20:00:00	2025-06-23 05:00:00.678	2025-06-23 12:00:00.774	defad9f9-3de6-469a-bcd5-9df622c6381a	7	c/o Rachel / Richard-Rasool-1C\nfarsana 8 bloosoms hot pot  1\nkumbakom cafe 1\n\nFULL	["S2", "S3", "S4", "S5", "S6", "S8", "S9"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-23 06:57:40.121	English	2025-07-01 10:18:09.491
ea62b9f3-85ac-45ae-848a-e84ea01b9aa0	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-07-15 20:00:00	2025-07-02 05:00:00.553	2025-07-02 12:00:00.377	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Raquel-Int'l Grand Mart-9tbc / 	[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-07-02 11:56:20.385	English	2025-07-04 05:05:31.739
0ea802d2-4b63-4ac9-9bde-c94cb66bef60	29404c10-56eb-4644-9309-6fdeae3e6ad2	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-13 20:00:00	2025-07-01 05:00:00.473	2025-07-01 09:30:00.216	defad9f9-3de6-469a-bcd5-9df622c6381a	0	c/o Rachel/Farsana 10\nbin saleh grocery 1pax 0569234840 paid\n1 haris grocery\nfarooq grocery 1\nthayyib baqala 	[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-07-01 10:24:29.646	Malayalam	2025-07-04 13:03:04.517
24b6a71e-2f2f-4cde-8f02-aea4b413b9c2	a627bd22-2dbe-47d9-aaf1-309ec1ea9eba	3a5c78a8-1ab9-4a1e-805c-3457f307d2a1	2025-07-14 20:00:00	2025-06-25 05:00:00.594	2025-06-25 11:00:00.682	a659d3c7-6307-44c6-9e1e-7c2521903ee9	0	c/o Farsana	[]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-25 04:26:14.356	Malayalam	2025-06-30 10:46:41.21
8bd4dcc0-1903-4de0-b5f4-4bc39d966b9a	16b1c73c-125a-450e-84c5-c46eb35e8329	3a5c78a8-1ab9-4a1e-805c-3457f307d2a1	2025-07-08 20:00:00	2025-06-25 05:00:00.508	2025-06-25 12:00:00	a659d3c7-6307-44c6-9e1e-7c2521903ee9	0	Farsana-9C / 2tbc	[]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-25 04:13:20.208	Hindi	2025-07-05 11:11:26.439
36f26836-edd1-471d-b8e2-923a04a50458	6d1fa60c-9ca6-461d-a552-07d0e7378f50	f94ad229-b6e8-43da-ab5b-fd3821ad5166	2025-07-06 20:00:00	2025-06-25 05:00:00.555	2025-06-25 12:00:00.619	a23b6c2b-4517-4ca4-bf51-f1beb24061d5	0	Farnek Dubai - Inhouse session - Kamran 6 tbc / Hanusi 1 tbc / cancelled no confirmation for the incharge	[]	d62b351d-25f5-4c3b-b113-b1a0c2ec0cc7	2025-06-25 07:00:41.692	English	2025-07-05 10:57:44.588
15fa42ed-798b-4fdb-98d1-016025c33e70	0542daa1-3922-4e3c-b592-2837e583f1ed	3441a485-8338-4c27-90fc-b7dd2bea0c62	2025-07-06 20:00:00	2025-06-24 05:00:00.5	2025-06-24 12:00:00.659	70da7f6e-53ac-4a81-a34d-294ede59b8f1	6	c/o ABHI,confirmed-13	["S3", "S2", "S8", "S15", "S10", "S11"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-24 11:14:03.434	Hindi	2025-07-05 11:08:38.323
488af785-ace1-4780-8f7a-d8392c497943	29404c10-56eb-4644-9309-6fdeae3e6ad2	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-31 20:00:00	2025-06-24 05:00:00.987	2025-06-24 09:30:00.146	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Shihab-Almarai Abu Dhabi	[]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-24 04:20:45.108	English	2025-06-24 04:23:49.661
10c49793-4076-4902-a6a9-4db7cdef0439	29404c10-56eb-4644-9309-6fdeae3e6ad2	903a19f1-5fb1-42f7-8475-50d522495a81	2025-07-09 20:00:00	2025-06-24 05:00:00.148	2025-06-24 09:30:00.363	defad9f9-3de6-469a-bcd5-9df622c6381a	1	C/O Rachel\n\nDay to day 1 / organic monaco 2 paid / Mary-KM Trading-tbc	["S1"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-24 07:00:06.621	Hindi	2025-07-02 12:30:10.098
1034b03a-b13a-41aa-bc1d-bccfa9f6ef6b	29404c10-56eb-4644-9309-6fdeae3e6ad2	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-08-21 20:00:00	2025-06-24 05:00:00.738	2025-06-24 12:00:00.105	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Shihab-Almarai Abu Dhabi	[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-24 04:33:10.316	English	2025-06-24 04:33:10.316
ad6680e5-f32a-4dd8-b98d-214536fa42b0	29404c10-56eb-4644-9309-6fdeae3e6ad2	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-08-28 20:00:00	2025-06-24 05:00:00.738	2025-06-24 09:30:00	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Shihab-Almarai Abu Dhabi	[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-24 04:33:24.383	English	2025-06-24 04:33:24.383
c1d08a23-7c16-4ca1-8976-cde69d30ffeb	0542daa1-3922-4e3c-b592-2837e583f1ed	3441a485-8338-4c27-90fc-b7dd2bea0c62	2025-06-23 20:00:00	2025-06-24 05:00:00.114	2025-06-24 09:30:00	70da7f6e-53ac-4a81-a34d-294ede59b8f1	6	Shihab-Almarai Abu Dhabi	["S2", "S3", "S6", "S7", "S8", "S9"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-24 04:31:03.649	English	2025-06-24 07:15:56.402
7a84551c-3247-42aa-8c68-43048d2d1435	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-23 20:00:00	2025-07-03 05:00:00.175	2025-07-03 12:00:00.551	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Josephine FASSCO Danat 3tbc	[]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-07-03 12:44:33.398	English	2025-07-03 12:47:05.212
9bdf5373-abf6-4aff-8007-641024e76f31	a627bd22-2dbe-47d9-aaf1-309ec1ea9eba	3a5c78a8-1ab9-4a1e-805c-3457f307d2a1	2025-07-09 20:00:00	2025-06-25 05:00:00.194	2025-06-25 12:00:00.386	a659d3c7-6307-44c6-9e1e-7c2521903ee9	0	Roy-Galadari-5tbc\nOmar-Nut-5tbc	[]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-25 04:22:07.816	English	2025-06-26 11:43:01.917
484856e6-7920-4f7e-b4b7-e4dbf83ec95f	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-08-06 20:00:00	2025-07-04 05:00:00.897	2025-07-04 12:00:00.793	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Josephine FASSCO Danat 3tbc	[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-07-04 05:12:27.361	English	2025-07-04 05:15:27.853
08e147e3-90be-4ee0-b5ce-78f2a9862b4d	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-08 20:00:00	2025-06-24 05:00:00.843	2025-06-24 12:00:00.163	defad9f9-3de6-469a-bcd5-9df622c6381a	1	c/o Rachel\n grandmas  3\njanana-1	["S1"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-24 05:40:49.571	Hindi	2025-07-05 07:15:17.678
826203ed-87ab-4f3e-9cc9-7e41bec15c4e	471a65f6-e385-499a-9846-8d0157da3274	a01b7e54-90d0-49c6-b3fe-005851f5b51c	2025-06-27 20:00:00	2025-06-23 05:00:00.658	2025-06-23 11:00:00.938	913136c0-b58e-4f31-9091-9fb0d2105495	2	Spinco-Carla-3C	["S1", "S2"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-23 10:29:07.198	English	2025-06-30 07:45:16.827
68f6a078-0df4-4756-b78d-5e74f11a3dc1	a00b0601-15c9-47c6-9328-d2c743df2cd4	22d495d0-e1c3-4c25-885d-e81f9b25cd9c	2025-07-01 20:00:00	2025-06-30 09:00:00.202	2025-06-30 12:00:00.778	ac4f3060-6c9c-4039-be62-442b8e5b0e1f	2	Mr. Usama-Arabica/Hili Coffee (Emirates Hospitality) - 3C	["S1", "S2"]	5327210a-891d-4ad6-a000-d253c474d085	2025-06-30 04:07:54.64	English	2025-07-02 05:07:42.123
96532306-74f5-4529-b2b4-530ace7c27cf	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-07-07 20:00:00	2025-06-28 05:00:00.338	2025-06-28 12:00:00.906	defad9f9-3de6-469a-bcd5-9df622c6381a	0	McDonalds-replacement for cancelled session last July 2, 2025	[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-28 10:03:22.628	English	2025-07-01 04:23:21.293
7249bb19-2425-4574-b18c-772c7004aab9	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-07-08 20:00:00	2025-06-30 05:00:00.56	2025-06-30 12:00:00.264	70da7f6e-53ac-4a81-a34d-294ede59b8f1	14	c/o Abhi / Raquel-Int'l Grandmart-4C	["S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8", "S10", "S11", "S12", "S13", "S14", "S15"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-30 11:50:13.942	English	2025-07-05 05:20:31.746
fd09836c-43c7-4787-925a-4a6547df9e72	0542daa1-3922-4e3c-b592-2837e583f1ed	3441a485-8338-4c27-90fc-b7dd2bea0c62	2025-06-25 20:00:00	2025-06-21 05:00:00.217	2025-06-21 12:00:00.058	70da7f6e-53ac-4a81-a34d-294ede59b8f1	10	confirmed-12 ,not confirmed-3(Rotana)	["S1", "S2", "S3", "S11", "S5", "S13", "S4", "S6", "S7", "S9"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-21 10:16:39.226	Hindi	2025-06-26 06:26:38.989
41e351b1-0a7a-49b1-be0b-14a440f6e5e6	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-07-13 20:00:00	2025-07-02 05:00:00.697	2025-07-02 12:00:00.681	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Raquel - Int'l Grand Mart-9tbc / 	[]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-07-02 11:57:35.667	English	2025-07-04 05:05:13.614
fa8e2256-f8af-4211-be03-68757b768292	3be29657-6775-40e1-b04b-96d7d70205d4	fd214097-4e36-45d7-a273-4d79d054397e	2025-07-01 20:00:00	2025-06-28 05:00:00.944	2025-06-28 09:00:00.655	ac4f3060-6c9c-4039-be62-442b8e5b0e1f	0	Arabic/Hili Coffee (Emirates Hospitality)-Usama-3C	[]	5327210a-891d-4ad6-a000-d253c474d085	2025-06-28 09:26:57.508	English	2025-06-30 04:06:41.65
d22317e7-e59b-477e-baff-138e3ba08bcf	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-08-03 20:00:00	2025-07-04 05:00:00.897	2025-07-04 12:00:00.793	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Josephine FASSCO Danat 3tbc	[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-07-04 05:11:37.234	English	2025-07-04 05:14:51.359
2ff62317-66db-492b-80cb-f5c2b83644d7	29404c10-56eb-4644-9309-6fdeae3e6ad2	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-10 20:00:00	2025-06-28 05:00:00.747	2025-06-28 09:30:00	defad9f9-3de6-469a-bcd5-9df622c6381a	0	c/o Rachel / 3 tinoh / Mary KM Trading tbc \ndistination 1 fj mart	[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-28 10:39:17.292	English	2025-07-05 07:04:56.926
126e6773-b900-4243-91ee-46ffa2945e53	2ea7bb56-6dc5-4e0c-bb23-16169ff07760	8855c5cd-3cd6-4e72-a68e-10dede71c58d	2025-07-01 20:00:00	2025-06-21 05:00:00.576	2025-06-21 12:00:00.656	52025b2e-983a-4d3d-be75-420858d98d67	0	Siyan-Confirmed to start every Wednesday - Start date July 2, 2025. Trainer - ANN SURYA	[]	d62b351d-25f5-4c3b-b113-b1a0c2ec0cc7	2025-06-21 10:35:08.048	English	2025-06-28 05:44:32.329
7003baa5-f4fd-4046-8616-c262bb72f1c6	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-07-04 20:00:00	2025-06-26 05:00:00.779	2025-06-26 12:00:00.331	70da7f6e-53ac-4a81-a34d-294ede59b8f1	5	c/o Abhi/Farsana	["S13", "S5", "S6", "S8", "S9"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-26 10:11:47.093	English	2025-07-05 06:41:03.286
8cfe99e6-f724-4928-9fa8-4ab14817c1e3	4b7bbda3-36c9-4dab-bd83-89cc973eef60	806b93d5-3fbd-4766-8745-f81e24bc63e3	2025-06-29 20:00:00	2025-06-28 10:00:00.553	2025-06-28 11:00:00.161	defad9f9-3de6-469a-bcd5-9df622c6381a	2	Alzhraa Yaser Zoghbi-PC Supervisor-2C (re-exam)	["S2", "S1"]	eed5630f-3991-4da6-9ffe-a1cabc7afba5	2025-06-28 06:39:31.084	English	2025-07-02 09:59:29.308
f84cc6b8-de5f-4cad-9ee4-c5de7fcfb362	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-07-08 20:00:00	2025-06-25 05:00:00.38	2025-06-25 12:00:00.148	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Monaco Bar 4  \ntru boutique 2\ncinema 6\npanaderia 1\nFritz Cafe  1 \njanana \nFULL \n	[]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-25 11:22:21.769	English	2025-07-05 10:22:25.678
f8109649-9db6-42a7-8b03-4ea280b77369	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-07-02 20:00:00	2025-06-23 05:00:00.328	2025-06-23 12:00:00.854	70da7f6e-53ac-4a81-a34d-294ede59b8f1	7	c/o Abhi	["S15", "S5", "S12", "S6", "S13", "S4", "S1"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-23 08:19:55.396	Hindi	2025-07-03 09:01:57.067
03ceabeb-e0a6-4436-b4dc-22f6e9ce486a	29404c10-56eb-4644-9309-6fdeae3e6ad2	18f1522e-7266-4730-89cc-2033cc2632db	2025-07-18 20:00:00	2025-06-30 05:00:00.56	2025-06-30 12:00:00.264	70da7f6e-53ac-4a81-a34d-294ede59b8f1	6	Trainer-Ibrahim/ only 4 confirmed / Mary KM Trading tbc,AL Yasmeen- 5 pax not confirmed.,Al hor-2 slots (rachel )\n	["S1", "S2", "S4", "S14", "S6", "S7"]	0939047c-a65e-49f6-a5e2-d18de56bbd01	2025-06-30 11:51:41.857	Arabic	2025-07-05 11:11:32.607
ee18c105-2f9f-44e8-8b6c-4a62d7230fcb	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-15 20:00:00	2025-06-26 05:00:00.507	2025-06-26 12:00:00.083	defad9f9-3de6-469a-bcd5-9df622c6381a	0	c/o Rachel	[]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-26 06:58:31.558	Hindi	2025-06-28 11:25:31.266
d13d98b1-3085-45b2-ba73-475e65821c91	16b1c73c-125a-450e-84c5-c46eb35e8329	3a5c78a8-1ab9-4a1e-805c-3457f307d2a1	2025-06-29 20:00:00	2025-06-28 05:00:00.21	2025-06-28 12:00:00.938	a659d3c7-6307-44c6-9e1e-7c2521903ee9	1	Al Bait Al Soury Restaurant & Roaster- 7C Arabic	["S7"]	0939047c-a65e-49f6-a5e2-d18de56bbd01	2025-06-28 06:51:48.304	Arabic	2025-06-30 08:30:01.196
d3461489-a74d-441b-87d5-d8155fc06768	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-07-07 20:00:00	2025-06-26 05:00:00.187	2025-06-26 12:00:00.682	70da7f6e-53ac-4a81-a34d-294ede59b8f1	6	c/o Abhi	["S9", "S10", "S11", "S13", "S14", "S15"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-26 12:46:41.398	English	2025-07-04 10:14:17.148
de66059e-7f74-4cee-87ba-5f2ef1d4cd4b	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-04 20:00:00	2025-06-28 05:00:00.806	2025-06-28 12:00:00.03	defad9f9-3de6-469a-bcd5-9df622c6381a	4	c/o Rachel-Move to new date\ngolden kattans 1\nchick girlls cafeteria \n5 PAX CONFIRM\n\n	["S1", "S3", "S5", "S4"]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-06-28 08:49:52.363	Hindi	2025-07-05 09:48:36.34
34d730a8-3aab-4892-92d1-e5cc3b928aae	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-07-06 20:00:00	2025-06-23 05:00:00.683	2025-06-23 12:00:00.019	defad9f9-3de6-469a-bcd5-9df622c6381a	9	McDonalds-15C	["S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8", "S9"]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-23 04:47:47.267	English	2025-07-05 07:04:22.063
4bc85338-67fc-4111-9dd0-732198a19e10	0542daa1-3922-4e3c-b592-2837e583f1ed	903a19f1-5fb1-42f7-8475-50d522495a81	2025-07-04 20:00:00	2025-06-28 05:00:00.806	2025-06-28 12:00:00.03	defad9f9-3de6-469a-bcd5-9df622c6381a	6	FULL \n\nfamily ref 1 al kulaifi 1	["S8", "S10", "S13", "S4", "S5", "S7"]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-28 08:50:13.233	Malayalam	2025-07-05 10:20:01.44
840512b5-15b8-427a-aa6d-3c6333972177	8057479a-6cba-4996-a7f7-52b54f2949be	806b93d5-3fbd-4766-8745-f81e24bc63e3	2025-07-01 20:00:00	2025-06-30 10:30:00	2025-06-30 11:30:00	defad9f9-3de6-469a-bcd5-9df622c6381a	0	c/o Mr. Satrmesh-Eagle Abu Dhabi - 10 C	[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-06-30 09:34:09.356	English	2025-07-01 04:37:58.253
a671c2c7-441f-4c67-9514-5f91ec40e6fd	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-07-10 20:00:00	2025-07-01 05:00:00.929	2025-07-01 12:00:00.457	70da7f6e-53ac-4a81-a34d-294ede59b8f1	3	c/o Abhi	["S3", "S4", "S5"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-07-01 04:55:55.697	Malayalam	2025-07-04 11:32:23.11
77b7284c-93f5-4e5a-b1da-7933f8641b7e	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-07-11 20:00:00	2025-06-30 05:00:00.56	2025-06-30 12:00:00.264	70da7f6e-53ac-4a81-a34d-294ede59b8f1	12	Trainer-Ibrahim	["S1", "S2", "S3", "S5", "S6", "S7", "S9", "S10", "S11", "S12", "S13", "S14"]	0939047c-a65e-49f6-a5e2-d18de56bbd01	2025-06-30 11:53:47.833	Arabic	2025-07-03 11:14:10.965
56052edb-174e-417d-9d67-4717ca8a82be	8057479a-6cba-4996-a7f7-52b54f2949be	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-01 20:00:00	2025-07-01 10:30:00	2025-07-01 11:30:00	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Satrmesh-Eagle Environmental Abu Dhabi - 9C	[]	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a	2025-07-01 04:36:36.485	English	2025-07-01 04:36:36.485
9f5a82f7-88ed-449d-a5fa-a58011ced5d3	6d1fa60c-9ca6-461d-a552-07d0e7378f50	a01b7e54-90d0-49c6-b3fe-005851f5b51c	2025-07-02 20:00:00	2025-07-01 05:00:00.121	2025-07-01 12:00:00.44	913136c0-b58e-4f31-9091-9fb0d2105495	0	Ms. Mira-The Heaf Cafe Dubai - 8C / Ann will attend the session	[]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-07-01 04:49:38.557	English	2025-07-01 04:50:15.722
b5bf9c33-d1b6-4519-8ca5-f91c3822d575	29404c10-56eb-4644-9309-6fdeae3e6ad2	3441a485-8338-4c27-90fc-b7dd2bea0c62	2025-07-07 20:00:00	2025-06-30 05:00:00.107	2025-06-30 09:30:00.019	70da7f6e-53ac-4a81-a34d-294ede59b8f1	9	al haj revision / Mary KM Trading tbc /	["S1", "S2", "S5", "S10", "S13", "S9", "S4", "S11", "S15"]	457b9c23-efb0-4abb-9722-67f602a1d4d8	2025-06-30 04:27:19.929	Malayalam	2025-07-04 12:15:15.049
6f16999c-8d4f-47d5-bf41-dc9457518c1f	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-08-05 20:00:00	2025-07-04 05:00:00.897	2025-07-04 12:00:00.793	defad9f9-3de6-469a-bcd5-9df622c6381a	0	Josephine FASSCO Danat 3tbc	[]	ef7e72b8-443c-4057-8381-9a489e01af35	2025-07-04 05:13:17.105	English	2025-07-04 05:15:07.727
0688a322-6cf0-46c1-be5b-16843424c70e	be0503b1-ff61-4eca-b4f9-be73b10e30cd	bc34f860-7278-46be-884a-26908f0924e5	2025-06-30 20:00:00	2025-07-01 06:30:00.432	2025-07-01 14:30:00.967	c64310d3-1151-4745-a352-083a5a93570f	1	Eng Ibrahim/John-1C	["S1"]	09fbabca-cb81-4f58-81ae-4b060edd6bef	2025-07-01 07:16:40.298	English	2025-07-01 09:11:50.885
4729c61f-a469-43e7-aa08-0984f1ab506e	be0503b1-ff61-4eca-b4f9-be73b10e30cd	bc34f860-7278-46be-884a-26908f0924e5	2025-07-01 20:00:00	2025-07-01 06:30:00.432	2025-07-01 14:30:00.967	c64310d3-1151-4745-a352-083a5a93570f	0		[]	09fbabca-cb81-4f58-81ae-4b060edd6bef	2025-07-01 07:16:47.949	English	2025-07-01 09:12:29.383
0e5ed940-8b1c-4e20-94ff-d94366bf5a35	be0503b1-ff61-4eca-b4f9-be73b10e30cd	bc34f860-7278-46be-884a-26908f0924e5	2025-07-02 20:00:00	2025-07-01 06:30:00.432	2025-07-01 14:30:00.967	c64310d3-1151-4745-a352-083a5a93570f	1		["S1"]	09fbabca-cb81-4f58-81ae-4b060edd6bef	2025-07-01 07:16:54.916	English	2025-07-01 09:13:07.932
fb432925-508e-402b-8425-37675297f794	6d1fa60c-9ca6-461d-a552-07d0e7378f50	7103911f-063f-46c7-b01a-e86d1a4cb765	2025-07-12 20:00:00	2025-07-05 05:00:00.165	2025-07-05 12:00:00.197	05e3a99d-c242-427c-88a8-7702a88712e6	0	Almarai DIC & DW	[]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-07-05 04:40:11.63	English	2025-07-05 05:10:47.654
d4ce55cd-5df1-4d19-9e33-fdeec723c9b8	be0503b1-ff61-4eca-b4f9-be73b10e30cd	bc34f860-7278-46be-884a-26908f0924e5	2025-06-29 20:00:00	2025-07-01 06:30:00.647	2025-07-01 14:30:00.544	c64310d3-1151-4745-a352-083a5a93570f	1	Eng Ibrahim/John-1C	["S1"]	09fbabca-cb81-4f58-81ae-4b060edd6bef	2025-07-01 07:14:15.946	English	2025-07-01 09:10:44.283
6903f207-d73c-4a47-a4e2-2320c81e268f	be0503b1-ff61-4eca-b4f9-be73b10e30cd	bc34f860-7278-46be-884a-26908f0924e5	2025-07-03 20:00:00	2025-07-01 06:30:00.432	2025-07-01 14:30:00.967	c64310d3-1151-4745-a352-083a5a93570f	0		[]	09fbabca-cb81-4f58-81ae-4b060edd6bef	2025-07-01 07:17:06.168	English	2025-07-01 09:13:48.937
09aea980-92a0-4ba5-896f-e3908ce20f4a	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-07-25 20:00:00	2025-06-30 05:00:00.56	2025-06-30 12:00:00.264	70da7f6e-53ac-4a81-a34d-294ede59b8f1	5	Trainer-Ibrahim	["S1", "S4", "S5", "S7", "S2"]	0939047c-a65e-49f6-a5e2-d18de56bbd01	2025-06-30 11:52:12.45	Arabic	2025-07-04 10:11:26.406
15ec65dc-bd6f-41a7-a8b6-d10c86a7b51a	0542daa1-3922-4e3c-b592-2837e583f1ed	5aaee169-9f72-4594-8f60-cbb04081bfbd	2025-07-14 20:00:00	2025-07-01 05:00:00.564	2025-07-01 12:00:00.299	defad9f9-3de6-469a-bcd5-9df622c6381a	0	c/o Rachel / kanjan 1 retake  / prince 1 / Nabeel (URS)- 8\nurs hold certificate as per accounts 	[]	b14ef552-2080-419d-b1dd-d91a49433625	2025-07-01 05:50:05.413	Arabic	2025-07-04 09:44:56.078
bcdf98c4-3d84-457b-8111-d841226ac15c	0542daa1-3922-4e3c-b592-2837e583f1ed	18f1522e-7266-4730-89cc-2033cc2632db	2025-07-14 20:00:00	2025-07-04 05:00:00.219	2025-07-04 12:00:00.611	70da7f6e-53ac-4a81-a34d-294ede59b8f1	5		["S1", "S2", "S3", "S5", "S6"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-07-04 08:38:57.309	Hindi	2025-07-05 06:35:37.806
c65f2289-efa4-4773-9d49-3900f0bd95ff	29404c10-56eb-4644-9309-6fdeae3e6ad2	3441a485-8338-4c27-90fc-b7dd2bea0c62	2025-07-09 20:00:00	2025-06-30 05:00:00.56	2025-06-30 09:30:00	70da7f6e-53ac-4a81-a34d-294ede59b8f1	2	c/o Abhi,Mary KM Trading tbc	["S2", "S4"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-06-30 11:57:24.795	Hindi	2025-07-04 11:47:29.468
149fd6d6-467d-468e-a13c-b2a291200b40	8057479a-6cba-4996-a7f7-52b54f2949be	14ff8c3f-5667-412e-9f09-8a3a47276e1c	2025-06-30 20:00:00	2025-07-01 13:00:00.144	2025-07-01 14:00:00.944	7cee0c69-32f3-4a95-b29b-564dfdb51f09	7	Ahmed-AKI-12C	["S1", "S2", "S4", "S5", "S6", "S8", "S12"]	574a5211-7cca-48cb-ac8b-d4b8839cd1af	2025-07-01 04:30:12.579	English	2025-07-02 05:06:54.057
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."User" (id, name, email, phone, role, password, "createdAt", "updatedAt", "firstName", "lastName", "phoneNumber") FROM stdin;
afd096ab-f877-47e7-871e-0aa52ae6970b	hello	hello@zyypher.com	\N	VIEWER	$2b$10$Z/amVMn033Cnr0brZ2du2.3GiMeZtQzApxtN/RCnjja82Yzd4J6Iq	2025-05-13 17:34:05.486	2025-05-13 17:36:41.506	\N	\N	\N
2ff16340-0d91-4db0-bd56-bdb8783872ff	RMK Admin	admin@rmkexperts.com	\N	ADMIN	$2b$12$sfpfk13PKrocTNKENbnLtebmQicXsK6quEzIDw8qYyDutmzC6kiLi	2025-05-06 19:08:03.789	2025-05-22 18:35:46.049	Admin	\N	\N
0e5b8caa-a8e8-40e2-aaec-2bbbd5b67ede	vishnv336	vishnv336@gmail.com	\N	EDITOR	\N	2025-06-11 16:44:53.922	2025-06-11 16:44:53.922	\N	\N	\N
6dc5236f-7d35-4ce5-a860-ef4bdfab80a2	therealvishnuvinayan	therealvishnuvinayan@gmail.com	\N	ADMIN	\N	2025-06-11 16:46:53.249	2025-06-11 16:46:53.249	\N	\N	\N
18d4f81c-2130-419c-bea9-7087811d15fd	abudhabi	abudhabi@rmktheexperts.com	\N	EDITOR	$2b$10$viZbSPtAqpj8js9JLy/9vu2cHxa.EijaCl473caeuLO82BR1BWYSe	2025-06-20 12:49:53.636	2025-06-20 12:50:28.959	\N	\N	\N
998beac6-b95d-4d3c-b498-832c8cf32680	alain	alain@rmktheexperts.com	\N	EDITOR	$2b$10$R9z18DcK4mCJRQ88arE5/uA4TpHYKDm5SeN4G84.St3jVg/4uM/Bi	2025-06-21 07:16:04.257	2025-06-21 07:24:00.211	\N	\N	\N
\.


--
-- Data for Name: _CourseLanguages; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."_CourseLanguages" ("A", "B") FROM stdin;
6d1fa60c-9ca6-461d-a552-07d0e7378f50	19fb92ce-85fe-4673-8a17-31cc6a204297
e0f45b2f-55e7-4a6f-a65f-d3d9c9409372	19fb92ce-85fe-4673-8a17-31cc6a204297
e0f45b2f-55e7-4a6f-a65f-d3d9c9409372	85ac039b-c015-47e8-afee-0d09d4716f63
6d1fa60c-9ca6-461d-a552-07d0e7378f50	85ac039b-c015-47e8-afee-0d09d4716f63
6d1fa60c-9ca6-461d-a552-07d0e7378f50	afe9d414-6434-4ec2-8901-92f22eafa437
6d1fa60c-9ca6-461d-a552-07d0e7378f50	676331e2-4477-42c2-a455-9c7b49fabefd
6d1fa60c-9ca6-461d-a552-07d0e7378f50	86ea0c23-901c-4f1f-a88f-ada725771418
6d1fa60c-9ca6-461d-a552-07d0e7378f50	05888b8f-8985-4615-807c-7420e9dd6935
d7dc0686-718a-491f-92c4-6bfb7745b8bc	19fb92ce-85fe-4673-8a17-31cc6a204297
d7dc0686-718a-491f-92c4-6bfb7745b8bc	85ac039b-c015-47e8-afee-0d09d4716f63
d7dc0686-718a-491f-92c4-6bfb7745b8bc	afe9d414-6434-4ec2-8901-92f22eafa437
d7dc0686-718a-491f-92c4-6bfb7745b8bc	676331e2-4477-42c2-a455-9c7b49fabefd
d7dc0686-718a-491f-92c4-6bfb7745b8bc	86ea0c23-901c-4f1f-a88f-ada725771418
d7dc0686-718a-491f-92c4-6bfb7745b8bc	05888b8f-8985-4615-807c-7420e9dd6935
3d0a9897-53ae-429e-bbfc-4811694142b0	85ac039b-c015-47e8-afee-0d09d4716f63
cf9c2fba-baf9-441e-a72a-dc7c1939683d	19fb92ce-85fe-4673-8a17-31cc6a204297
cf9c2fba-baf9-441e-a72a-dc7c1939683d	85ac039b-c015-47e8-afee-0d09d4716f63
2ea7bb56-6dc5-4e0c-bb23-16169ff07760	19fb92ce-85fe-4673-8a17-31cc6a204297
2ea7bb56-6dc5-4e0c-bb23-16169ff07760	85ac039b-c015-47e8-afee-0d09d4716f63
2ea7bb56-6dc5-4e0c-bb23-16169ff07760	afe9d414-6434-4ec2-8901-92f22eafa437
2ea7bb56-6dc5-4e0c-bb23-16169ff07760	676331e2-4477-42c2-a455-9c7b49fabefd
2ea7bb56-6dc5-4e0c-bb23-16169ff07760	86ea0c23-901c-4f1f-a88f-ada725771418
3d0a9897-53ae-429e-bbfc-4811694142b0	afe9d414-6434-4ec2-8901-92f22eafa437
3d0a9897-53ae-429e-bbfc-4811694142b0	676331e2-4477-42c2-a455-9c7b49fabefd
3d0a9897-53ae-429e-bbfc-4811694142b0	86ea0c23-901c-4f1f-a88f-ada725771418
3d0a9897-53ae-429e-bbfc-4811694142b0	05888b8f-8985-4615-807c-7420e9dd6935
a00b0601-15c9-47c6-9328-d2c743df2cd4	19fb92ce-85fe-4673-8a17-31cc6a204297
a00b0601-15c9-47c6-9328-d2c743df2cd4	85ac039b-c015-47e8-afee-0d09d4716f63
a00b0601-15c9-47c6-9328-d2c743df2cd4	afe9d414-6434-4ec2-8901-92f22eafa437
a00b0601-15c9-47c6-9328-d2c743df2cd4	676331e2-4477-42c2-a455-9c7b49fabefd
a00b0601-15c9-47c6-9328-d2c743df2cd4	86ea0c23-901c-4f1f-a88f-ada725771418
a00b0601-15c9-47c6-9328-d2c743df2cd4	05888b8f-8985-4615-807c-7420e9dd6935
be0503b1-ff61-4eca-b4f9-be73b10e30cd	19fb92ce-85fe-4673-8a17-31cc6a204297
6b92a3b0-f5b2-4ec3-a9ae-9a1a05a58989	19fb92ce-85fe-4673-8a17-31cc6a204297
6b92a3b0-f5b2-4ec3-a9ae-9a1a05a58989	85ac039b-c015-47e8-afee-0d09d4716f63
6b92a3b0-f5b2-4ec3-a9ae-9a1a05a58989	afe9d414-6434-4ec2-8901-92f22eafa437
6b92a3b0-f5b2-4ec3-a9ae-9a1a05a58989	676331e2-4477-42c2-a455-9c7b49fabefd
6b92a3b0-f5b2-4ec3-a9ae-9a1a05a58989	86ea0c23-901c-4f1f-a88f-ada725771418
6b92a3b0-f5b2-4ec3-a9ae-9a1a05a58989	05888b8f-8985-4615-807c-7420e9dd6935
3d1b1703-2450-4ff1-9cee-2ad320d63959	19fb92ce-85fe-4673-8a17-31cc6a204297
3d1b1703-2450-4ff1-9cee-2ad320d63959	afe9d414-6434-4ec2-8901-92f22eafa437
29404c10-56eb-4644-9309-6fdeae3e6ad2	19fb92ce-85fe-4673-8a17-31cc6a204297
29404c10-56eb-4644-9309-6fdeae3e6ad2	85ac039b-c015-47e8-afee-0d09d4716f63
29404c10-56eb-4644-9309-6fdeae3e6ad2	afe9d414-6434-4ec2-8901-92f22eafa437
29404c10-56eb-4644-9309-6fdeae3e6ad2	676331e2-4477-42c2-a455-9c7b49fabefd
29404c10-56eb-4644-9309-6fdeae3e6ad2	86ea0c23-901c-4f1f-a88f-ada725771418
29404c10-56eb-4644-9309-6fdeae3e6ad2	05888b8f-8985-4615-807c-7420e9dd6935
0542daa1-3922-4e3c-b592-2837e583f1ed	19fb92ce-85fe-4673-8a17-31cc6a204297
0542daa1-3922-4e3c-b592-2837e583f1ed	85ac039b-c015-47e8-afee-0d09d4716f63
0542daa1-3922-4e3c-b592-2837e583f1ed	afe9d414-6434-4ec2-8901-92f22eafa437
0542daa1-3922-4e3c-b592-2837e583f1ed	676331e2-4477-42c2-a455-9c7b49fabefd
0542daa1-3922-4e3c-b592-2837e583f1ed	86ea0c23-901c-4f1f-a88f-ada725771418
0542daa1-3922-4e3c-b592-2837e583f1ed	05888b8f-8985-4615-807c-7420e9dd6935
db9d765a-79b1-404c-b83d-9398dcd097fb	19fb92ce-85fe-4673-8a17-31cc6a204297
db9d765a-79b1-404c-b83d-9398dcd097fb	85ac039b-c015-47e8-afee-0d09d4716f63
db9d765a-79b1-404c-b83d-9398dcd097fb	afe9d414-6434-4ec2-8901-92f22eafa437
db9d765a-79b1-404c-b83d-9398dcd097fb	676331e2-4477-42c2-a455-9c7b49fabefd
db9d765a-79b1-404c-b83d-9398dcd097fb	86ea0c23-901c-4f1f-a88f-ada725771418
db9d765a-79b1-404c-b83d-9398dcd097fb	05888b8f-8985-4615-807c-7420e9dd6935
4bad3ec0-f571-4ffe-9504-737ec0db74f0	19fb92ce-85fe-4673-8a17-31cc6a204297
4bad3ec0-f571-4ffe-9504-737ec0db74f0	85ac039b-c015-47e8-afee-0d09d4716f63
2ea7bb56-6dc5-4e0c-bb23-16169ff07760	05888b8f-8985-4615-807c-7420e9dd6935
8057479a-6cba-4996-a7f7-52b54f2949be	19fb92ce-85fe-4673-8a17-31cc6a204297
1e88e10b-95f1-4b8e-9cfe-8b8a381a336d	19fb92ce-85fe-4673-8a17-31cc6a204297
1e88e10b-95f1-4b8e-9cfe-8b8a381a336d	85ac039b-c015-47e8-afee-0d09d4716f63
71c6f1e5-0fb5-4140-a0c4-3968493391b8	19fb92ce-85fe-4673-8a17-31cc6a204297
71c6f1e5-0fb5-4140-a0c4-3968493391b8	85ac039b-c015-47e8-afee-0d09d4716f63
71c6f1e5-0fb5-4140-a0c4-3968493391b8	afe9d414-6434-4ec2-8901-92f22eafa437
71c6f1e5-0fb5-4140-a0c4-3968493391b8	676331e2-4477-42c2-a455-9c7b49fabefd
71c6f1e5-0fb5-4140-a0c4-3968493391b8	86ea0c23-901c-4f1f-a88f-ada725771418
71c6f1e5-0fb5-4140-a0c4-3968493391b8	05888b8f-8985-4615-807c-7420e9dd6935
1e88e10b-95f1-4b8e-9cfe-8b8a381a336d	afe9d414-6434-4ec2-8901-92f22eafa437
1e88e10b-95f1-4b8e-9cfe-8b8a381a336d	676331e2-4477-42c2-a455-9c7b49fabefd
1e88e10b-95f1-4b8e-9cfe-8b8a381a336d	86ea0c23-901c-4f1f-a88f-ada725771418
1e88e10b-95f1-4b8e-9cfe-8b8a381a336d	05888b8f-8985-4615-807c-7420e9dd6935
4b7bbda3-36c9-4dab-bd83-89cc973eef60	19fb92ce-85fe-4673-8a17-31cc6a204297
ae67eb73-fb4f-49e5-9ba8-6a9d8102ea47	19fb92ce-85fe-4673-8a17-31cc6a204297
a627bd22-2dbe-47d9-aaf1-309ec1ea9eba	19fb92ce-85fe-4673-8a17-31cc6a204297
a627bd22-2dbe-47d9-aaf1-309ec1ea9eba	85ac039b-c015-47e8-afee-0d09d4716f63
a627bd22-2dbe-47d9-aaf1-309ec1ea9eba	afe9d414-6434-4ec2-8901-92f22eafa437
a627bd22-2dbe-47d9-aaf1-309ec1ea9eba	676331e2-4477-42c2-a455-9c7b49fabefd
a627bd22-2dbe-47d9-aaf1-309ec1ea9eba	86ea0c23-901c-4f1f-a88f-ada725771418
a627bd22-2dbe-47d9-aaf1-309ec1ea9eba	05888b8f-8985-4615-807c-7420e9dd6935
16b1c73c-125a-450e-84c5-c46eb35e8329	19fb92ce-85fe-4673-8a17-31cc6a204297
16b1c73c-125a-450e-84c5-c46eb35e8329	85ac039b-c015-47e8-afee-0d09d4716f63
16b1c73c-125a-450e-84c5-c46eb35e8329	afe9d414-6434-4ec2-8901-92f22eafa437
16b1c73c-125a-450e-84c5-c46eb35e8329	676331e2-4477-42c2-a455-9c7b49fabefd
16b1c73c-125a-450e-84c5-c46eb35e8329	86ea0c23-901c-4f1f-a88f-ada725771418
16b1c73c-125a-450e-84c5-c46eb35e8329	05888b8f-8985-4615-807c-7420e9dd6935
0e0fa1fb-a033-4162-85d7-fe0835f78830	19fb92ce-85fe-4673-8a17-31cc6a204297
0e0fa1fb-a033-4162-85d7-fe0835f78830	85ac039b-c015-47e8-afee-0d09d4716f63
0e0fa1fb-a033-4162-85d7-fe0835f78830	afe9d414-6434-4ec2-8901-92f22eafa437
0e0fa1fb-a033-4162-85d7-fe0835f78830	676331e2-4477-42c2-a455-9c7b49fabefd
0e0fa1fb-a033-4162-85d7-fe0835f78830	86ea0c23-901c-4f1f-a88f-ada725771418
0e0fa1fb-a033-4162-85d7-fe0835f78830	05888b8f-8985-4615-807c-7420e9dd6935
3be29657-6775-40e1-b04b-96d7d70205d4	19fb92ce-85fe-4673-8a17-31cc6a204297
3be29657-6775-40e1-b04b-96d7d70205d4	85ac039b-c015-47e8-afee-0d09d4716f63
3be29657-6775-40e1-b04b-96d7d70205d4	afe9d414-6434-4ec2-8901-92f22eafa437
3be29657-6775-40e1-b04b-96d7d70205d4	676331e2-4477-42c2-a455-9c7b49fabefd
3be29657-6775-40e1-b04b-96d7d70205d4	86ea0c23-901c-4f1f-a88f-ada725771418
3be29657-6775-40e1-b04b-96d7d70205d4	05888b8f-8985-4615-807c-7420e9dd6935
1aab3af3-6afc-463d-8ed2-eaeff7dd4510	19fb92ce-85fe-4673-8a17-31cc6a204297
1aab3af3-6afc-463d-8ed2-eaeff7dd4510	85ac039b-c015-47e8-afee-0d09d4716f63
1aab3af3-6afc-463d-8ed2-eaeff7dd4510	afe9d414-6434-4ec2-8901-92f22eafa437
1aab3af3-6afc-463d-8ed2-eaeff7dd4510	676331e2-4477-42c2-a455-9c7b49fabefd
2c418f2d-c100-4f42-a4c1-e69af0c037ad	19fb92ce-85fe-4673-8a17-31cc6a204297
2c418f2d-c100-4f42-a4c1-e69af0c037ad	85ac039b-c015-47e8-afee-0d09d4716f63
471a65f6-e385-499a-9846-8d0157da3274	19fb92ce-85fe-4673-8a17-31cc6a204297
471a65f6-e385-499a-9846-8d0157da3274	85ac039b-c015-47e8-afee-0d09d4716f63
471a65f6-e385-499a-9846-8d0157da3274	afe9d414-6434-4ec2-8901-92f22eafa437
471a65f6-e385-499a-9846-8d0157da3274	676331e2-4477-42c2-a455-9c7b49fabefd
471a65f6-e385-499a-9846-8d0157da3274	86ea0c23-901c-4f1f-a88f-ada725771418
471a65f6-e385-499a-9846-8d0157da3274	05888b8f-8985-4615-807c-7420e9dd6935
3d0a9897-53ae-429e-bbfc-4811694142b0	19fb92ce-85fe-4673-8a17-31cc6a204297
\.


--
-- Data for Name: _TrainerCourses; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."_TrainerCourses" ("A", "B") FROM stdin;
16b1c73c-125a-450e-84c5-c46eb35e8329	9fccf438-8149-4945-9c86-4e46576472d7
a627bd22-2dbe-47d9-aaf1-309ec1ea9eba	9fccf438-8149-4945-9c86-4e46576472d7
2ea7bb56-6dc5-4e0c-bb23-16169ff07760	9fccf438-8149-4945-9c86-4e46576472d7
71c6f1e5-0fb5-4140-a0c4-3968493391b8	9fccf438-8149-4945-9c86-4e46576472d7
cf9c2fba-baf9-441e-a72a-dc7c1939683d	9fccf438-8149-4945-9c86-4e46576472d7
d7dc0686-718a-491f-92c4-6bfb7745b8bc	9fccf438-8149-4945-9c86-4e46576472d7
29404c10-56eb-4644-9309-6fdeae3e6ad2	9fccf438-8149-4945-9c86-4e46576472d7
16b1c73c-125a-450e-84c5-c46eb35e8329	457b9c23-efb0-4abb-9722-67f602a1d4d8
6d1fa60c-9ca6-461d-a552-07d0e7378f50	457b9c23-efb0-4abb-9722-67f602a1d4d8
29404c10-56eb-4644-9309-6fdeae3e6ad2	574a5211-7cca-48cb-ac8b-d4b8839cd1af
16b1c73c-125a-450e-84c5-c46eb35e8329	574a5211-7cca-48cb-ac8b-d4b8839cd1af
6b92a3b0-f5b2-4ec3-a9ae-9a1a05a58989	b14ef552-2080-419d-b1dd-d91a49433625
29404c10-56eb-4644-9309-6fdeae3e6ad2	b14ef552-2080-419d-b1dd-d91a49433625
0542daa1-3922-4e3c-b592-2837e583f1ed	b14ef552-2080-419d-b1dd-d91a49433625
db9d765a-79b1-404c-b83d-9398dcd097fb	b14ef552-2080-419d-b1dd-d91a49433625
29404c10-56eb-4644-9309-6fdeae3e6ad2	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a
16b1c73c-125a-450e-84c5-c46eb35e8329	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a
71c6f1e5-0fb5-4140-a0c4-3968493391b8	0939047c-a65e-49f6-a5e2-d18de56bbd01
6d1fa60c-9ca6-461d-a552-07d0e7378f50	0939047c-a65e-49f6-a5e2-d18de56bbd01
2ea7bb56-6dc5-4e0c-bb23-16169ff07760	0ef19354-4e29-4ab4-9515-7ee626e962bc
2ea7bb56-6dc5-4e0c-bb23-16169ff07760	a07a054a-d054-4e14-9bfb-45b5e8bd4f67
3be29657-6775-40e1-b04b-96d7d70205d4	1fb61a0f-44c0-4288-a705-bde8d51f93f4
16b1c73c-125a-450e-84c5-c46eb35e8329	09fbabca-cb81-4f58-81ae-4b060edd6bef
d7dc0686-718a-491f-92c4-6bfb7745b8bc	09fbabca-cb81-4f58-81ae-4b060edd6bef
0542daa1-3922-4e3c-b592-2837e583f1ed	ef7e72b8-443c-4057-8381-9a489e01af35
8057479a-6cba-4996-a7f7-52b54f2949be	eed5630f-3991-4da6-9ffe-a1cabc7afba5
2ea7bb56-6dc5-4e0c-bb23-16169ff07760	d62b351d-25f5-4c3b-b113-b1a0c2ec0cc7
3be29657-6775-40e1-b04b-96d7d70205d4	5327210a-891d-4ad6-a000-d253c474d085
0542daa1-3922-4e3c-b592-2837e583f1ed	ac0e715b-6b62-4edf-869d-93c341609999
be0503b1-ff61-4eca-b4f9-be73b10e30cd	841c652b-c0c9-4b20-9f8a-308169087999
\.


--
-- Data for Name: _TrainerLanguages; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."_TrainerLanguages" ("A", "B") FROM stdin;
19fb92ce-85fe-4673-8a17-31cc6a204297	9fccf438-8149-4945-9c86-4e46576472d7
afe9d414-6434-4ec2-8901-92f22eafa437	9fccf438-8149-4945-9c86-4e46576472d7
19fb92ce-85fe-4673-8a17-31cc6a204297	457b9c23-efb0-4abb-9722-67f602a1d4d8
afe9d414-6434-4ec2-8901-92f22eafa437	457b9c23-efb0-4abb-9722-67f602a1d4d8
676331e2-4477-42c2-a455-9c7b49fabefd	457b9c23-efb0-4abb-9722-67f602a1d4d8
19fb92ce-85fe-4673-8a17-31cc6a204297	574a5211-7cca-48cb-ac8b-d4b8839cd1af
676331e2-4477-42c2-a455-9c7b49fabefd	574a5211-7cca-48cb-ac8b-d4b8839cd1af
86ea0c23-901c-4f1f-a88f-ada725771418	574a5211-7cca-48cb-ac8b-d4b8839cd1af
19fb92ce-85fe-4673-8a17-31cc6a204297	b14ef552-2080-419d-b1dd-d91a49433625
85ac039b-c015-47e8-afee-0d09d4716f63	b14ef552-2080-419d-b1dd-d91a49433625
19fb92ce-85fe-4673-8a17-31cc6a204297	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a
676331e2-4477-42c2-a455-9c7b49fabefd	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a
05888b8f-8985-4615-807c-7420e9dd6935	7a0ca79c-33b0-4712-9963-a4b9aa30bc1a
19fb92ce-85fe-4673-8a17-31cc6a204297	0939047c-a65e-49f6-a5e2-d18de56bbd01
85ac039b-c015-47e8-afee-0d09d4716f63	0939047c-a65e-49f6-a5e2-d18de56bbd01
19fb92ce-85fe-4673-8a17-31cc6a204297	0ef19354-4e29-4ab4-9515-7ee626e962bc
85ac039b-c015-47e8-afee-0d09d4716f63	0ef19354-4e29-4ab4-9515-7ee626e962bc
19fb92ce-85fe-4673-8a17-31cc6a204297	a07a054a-d054-4e14-9bfb-45b5e8bd4f67
19fb92ce-85fe-4673-8a17-31cc6a204297	1fb61a0f-44c0-4288-a705-bde8d51f93f4
19fb92ce-85fe-4673-8a17-31cc6a204297	09fbabca-cb81-4f58-81ae-4b060edd6bef
19fb92ce-85fe-4673-8a17-31cc6a204297	ef7e72b8-443c-4057-8381-9a489e01af35
afe9d414-6434-4ec2-8901-92f22eafa437	ef7e72b8-443c-4057-8381-9a489e01af35
19fb92ce-85fe-4673-8a17-31cc6a204297	eed5630f-3991-4da6-9ffe-a1cabc7afba5
19fb92ce-85fe-4673-8a17-31cc6a204297	d62b351d-25f5-4c3b-b113-b1a0c2ec0cc7
afe9d414-6434-4ec2-8901-92f22eafa437	d62b351d-25f5-4c3b-b113-b1a0c2ec0cc7
676331e2-4477-42c2-a455-9c7b49fabefd	d62b351d-25f5-4c3b-b113-b1a0c2ec0cc7
19fb92ce-85fe-4673-8a17-31cc6a204297	5327210a-891d-4ad6-a000-d253c474d085
19fb92ce-85fe-4673-8a17-31cc6a204297	ac0e715b-6b62-4edf-869d-93c341609999
85ac039b-c015-47e8-afee-0d09d4716f63	ac0e715b-6b62-4edf-869d-93c341609999
19fb92ce-85fe-4673-8a17-31cc6a204297	841c652b-c0c9-4b20-9f8a-308169087999
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
24c14cfe-0b1d-4836-bada-ca0d82cced29	ea76b5b41449470dfba401fc2de2e202e37b3d36e82b3cae1462941cf10fead2	2025-05-19 15:15:48.259027+00	20250519151527_add_start_end_to_trainerleave	\N	\N	2025-05-19 15:15:46.62941+00	1
dcbfa64c-ec0e-4d6d-904b-105bdaf85f7c	ad5c3761183f7c0d98590a7473ca2dc4281412b7b70100b85ce34926dbf1fd06	2025-05-06 19:07:24.724781+00	20250422154502_init	\N	\N	2025-05-06 19:07:23.438607+00	1
03fc0911-05df-4e98-b9b3-3bedcac7cc95	2b1a9961a8ae727082b20f56037be949c3c6d4fa9748de2ae30ec083f35f3352	2025-05-06 19:07:50.367925+00	20250430164536_init	\N	\N	2025-05-06 19:07:49.104862+00	1
cb1a26f8-08a6-4eab-b117-471cea823f72	055624acc4707998e53e67061a48ade329c9e7f1ccb5f1ba538d5fd1099eddfb	2025-05-06 19:07:26.611608+00	20250422174642_trainer_language_time_availability	\N	\N	2025-05-06 19:07:25.210251+00	1
1ce20517-6a28-45a1-97c5-af6dd9a02ec4	81443b0b1c46fa00ae7af106f0dd47f5e8f3af17488433f6f15c6d6a87c38928	2025-05-06 19:07:28.491647+00	20250423131841_cascade_delete_user_tokens	\N	\N	2025-05-06 19:07:27.124315+00	1
06f55073-8ed6-465b-9c47-db98c9d627cc	4f90cf471458a878861d62dcb78d8967047867254849ea25c9beb86a067c1cd2	2025-05-06 19:07:30.50445+00	20250423132931_user_add_firsname	\N	\N	2025-05-06 19:07:29.069449+00	1
97cd6ea7-f380-4294-a038-2e79c3def2b6	0b6c4859884cbd912217a659387c0a40bfcc1860f414241e814e0cb8cb3ea659	2025-05-06 19:07:52.165625+00	20250503142232_update_location_model	\N	\N	2025-05-06 19:07:50.877489+00	1
a9ff3158-a3cd-417e-b42f-85906c968960	d3de5f2cd80538e3c81d7fa0cca7fdddc3706f4fe737d2acc46d28675b4dcd26	2025-05-06 19:07:32.960947+00	20250423144510_add_category_to_course	\N	\N	2025-05-06 19:07:31.515733+00	1
738f49be-02da-4103-9398-22dd617404b9	c76b09011991f63bd20a02be2137d0192c229a552090e19687a5c25c730da2b9	2025-05-06 19:07:35.008115+00	20250423154540_add_course_language_relation	\N	\N	2025-05-06 19:07:33.449046+00	1
af34976b-15b4-40aa-8075-6b2762afacc8	d162eef69b2bd682e5440ae33c621494e2263d1c555397df31da3c066eb6a653	2025-05-06 19:07:36.992053+00	20250425191945_rooms_init	\N	\N	2025-05-06 19:07:35.566238+00	1
8a431611-5a2f-4d46-b06b-bd269051cbfa	c33cdaf5c7d070ea04d3af02ddc48415774f1785abd5fa3773ba9a05406f3e4a	2025-05-06 19:07:54.055541+00	20250503144038_update_location_model1	\N	\N	2025-05-06 19:07:52.723944+00	1
6b8cec9c-9a8a-48f3-b657-af80141ede81	b9114d5eddfd7215cf4e7300fe596d74ff9ed54a9b6b24768747ffa6c29709fd	2025-05-06 19:07:39.001898+00	20250428141059_location_model	\N	\N	2025-05-06 19:07:37.568126+00	1
e1d0de4e-7cb0-4ce1-af74-13397b745f9b	f2d0d9d2775ca94706352de61c4c1000dcaeefc730a16ee651dd1bf2e8cf614a	2025-05-06 19:07:40.853355+00	20250428153054_add_trainer_schedule_relation	\N	\N	2025-05-06 19:07:39.616314+00	1
03c791f9-870f-4b80-a45b-2ab680019743	74d99548873fa78bc06af1a8bd61f279351a28861110e637725c8fb626a02f4a	2025-05-20 15:03:46.997146+00	20250520150329_add_client_landline_and_position	\N	\N	2025-05-20 15:03:45.866511+00	1
356663e1-6f61-4a28-b992-fd3fdac34491	d04d190e4da809677781208587f628e746c020af9d85a3e701207ea08dbb1ba6	2025-05-06 19:07:42.790445+00	20250428161302_add_allow_overlap_to_scheduling	\N	\N	2025-05-06 19:07:41.337378+00	1
8f7e153a-bf30-4340-a989-e448b6f58554	e1fd141edf3cf3481811177dd7a32ac9d55acaa97af446c3cbf4c483e7a821b4	2025-05-06 19:07:56.076125+00	20250503152017_remove_certificates	\N	\N	2025-05-06 19:07:54.568054+00	1
a58fb70c-7cde-4617-bae1-a599cdf4da4c	c35da91c256c467b5d6eb1bfacd0c33822784b1160b0e2b8f12ee96c9a1ca6b8	2025-05-06 19:07:44.578963+00	20250428173635_add_selected_seats	\N	\N	2025-05-06 19:07:43.339225+00	1
3b6661a0-947f-4bfe-89e4-c0c38178b520	61f87b50b00505821c5ced29bce1b5bc6da6669e757b1e5fd5ddeacc60673962	2025-05-06 19:07:46.924881+00	20250428191253_add_trainer_to_session	\N	\N	2025-05-06 19:07:45.568189+00	1
b2f08112-2102-49ce-9435-b47ab64157ed	29e67d21a5f15f9b91f1dfc36d3c2f28a6dd474261af02e07aeaaad18a326223	2025-05-06 19:07:48.621773+00	20250430153722_init	\N	\N	2025-05-06 19:07:47.407302+00	1
a149e303-e7c5-47d4-bb31-a26ccd864d35	c4afcd290957f9407e7bc54693a8a16e8342769d79a2cf6a14c121c2972a7b2c	2025-05-06 19:07:58.084433+00	20250503160643_add_delegate_model	\N	\N	2025-05-06 19:07:56.716505+00	1
176fb195-7370-4f4b-bc07-530cd4f467ad	acd26357500a0253f491bd1aa02bfe51682fcdb1385040334622842e341aaea4	2025-05-06 19:08:00.069332+00	20250504081002_add_seat_id_to_delegate	\N	\N	2025-05-06 19:07:58.663621+00	1
066d4fe4-6fa0-48aa-a3fd-ba015de1bde3	35b2e01b326aafae144c2ad96ec009aeffc6f828921310767a153a4e22e33ea8	2025-05-20 16:57:01.272584+00	20250520165642_add_quotation_and_paid_to_delegate	\N	\N	2025-05-20 16:57:00.034334+00	1
963df496-3a0c-497c-aa0f-9d929d5c9b19	3ae0e4060256fe615471b96f7e393b142315be72308864f93833332cb7169ffd	2025-05-06 19:08:01.836422+00	20250506155529_add_client_relation_to_delegate	\N	\N	2025-05-06 19:08:00.562214+00	1
98c67a6c-8b46-4275-bafc-83fa5a4cfc98	ab3fe6a50e741f5536c70c5bc22d1bd29198c3d02b5cdb930632ecb1eb4fe242	2025-05-19 14:38:31.540226+00	20250519143812_add_shortname_to_course	\N	\N	2025-05-19 14:38:30.268994+00	1
8ef44a32-8bac-424f-9336-5126c03c756b	ac2698d5def5b21b966385da6b7da11888868273caa94a688dfcf22fb7cb0f7f	2025-05-26 17:20:23.576336+00	20250526172006_make_client_email_required	\N	\N	2025-05-26 17:20:22.38969+00	1
77784c0a-0b8d-4e0c-87fa-562f1901374b	70f974bf36a4003aee57a92c98597639669bb2c9830052aed21aecffdf6b4ddb	2025-06-10 14:34:54.986035+00	20250610143432_add_location_colors	\N	\N	2025-06-10 14:34:53.634502+00	1
32a90003-4fae-4d0e-ba1f-556a5778c0c7	cee05bd7b6157c85960e4ff2a2f8c1aa80699ddf538a340c71b6038e18405adc	2025-06-10 15:28:41.949569+00	20250610152819_update_default_location_colors	\N	\N	2025-06-10 15:28:40.53226+00	1
\.


--
-- Name: Category Category_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "Category_pkey" PRIMARY KEY (id);


--
-- Name: Client Client_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Client"
    ADD CONSTRAINT "Client_pkey" PRIMARY KEY (id);


--
-- Name: Course Course_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Course"
    ADD CONSTRAINT "Course_pkey" PRIMARY KEY (id);


--
-- Name: DailyNote DailyNote_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."DailyNote"
    ADD CONSTRAINT "DailyNote_pkey" PRIMARY KEY (id);


--
-- Name: Delegate Delegate_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Delegate"
    ADD CONSTRAINT "Delegate_pkey" PRIMARY KEY (id);


--
-- Name: Language Language_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Language"
    ADD CONSTRAINT "Language_pkey" PRIMARY KEY (id);


--
-- Name: Location Location_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Location"
    ADD CONSTRAINT "Location_pkey" PRIMARY KEY (id);


--
-- Name: PasswordResetToken PasswordResetToken_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."PasswordResetToken"
    ADD CONSTRAINT "PasswordResetToken_pkey" PRIMARY KEY (id);


--
-- Name: Room Room_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Room"
    ADD CONSTRAINT "Room_pkey" PRIMARY KEY (id);


--
-- Name: TrainerLeave TrainerLeave_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."TrainerLeave"
    ADD CONSTRAINT "TrainerLeave_pkey" PRIMARY KEY (id);


--
-- Name: TrainerSchedulingRule TrainerSchedulingRule_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."TrainerSchedulingRule"
    ADD CONSTRAINT "TrainerSchedulingRule_pkey" PRIMARY KEY (id);


--
-- Name: Trainer Trainer_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Trainer"
    ADD CONSTRAINT "Trainer_pkey" PRIMARY KEY (id);


--
-- Name: TrainingSession TrainingSession_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."TrainingSession"
    ADD CONSTRAINT "TrainingSession_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: _CourseLanguages _CourseLanguages_AB_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."_CourseLanguages"
    ADD CONSTRAINT "_CourseLanguages_AB_pkey" PRIMARY KEY ("A", "B");


--
-- Name: _TrainerCourses _TrainerCourses_AB_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."_TrainerCourses"
    ADD CONSTRAINT "_TrainerCourses_AB_pkey" PRIMARY KEY ("A", "B");


--
-- Name: _TrainerLanguages _TrainerLanguages_AB_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."_TrainerLanguages"
    ADD CONSTRAINT "_TrainerLanguages_AB_pkey" PRIMARY KEY ("A", "B");


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: Category_name_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX "Category_name_key" ON public."Category" USING btree (name);


--
-- Name: Course_createdAt_idx; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX "Course_createdAt_idx" ON public."Course" USING btree ("createdAt");


--
-- Name: DailyNote_date_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX "DailyNote_date_key" ON public."DailyNote" USING btree (date);


--
-- Name: Language_name_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX "Language_name_key" ON public."Language" USING btree (name);


--
-- Name: PasswordResetToken_token_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX "PasswordResetToken_token_key" ON public."PasswordResetToken" USING btree (token);


--
-- Name: PasswordResetToken_userId_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX "PasswordResetToken_userId_key" ON public."PasswordResetToken" USING btree ("userId");


--
-- Name: TrainerSchedulingRule_trainerId_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX "TrainerSchedulingRule_trainerId_key" ON public."TrainerSchedulingRule" USING btree ("trainerId");


--
-- Name: TrainingSession_createdAt_idx; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX "TrainingSession_createdAt_idx" ON public."TrainingSession" USING btree ("createdAt");


--
-- Name: User_createdAt_idx; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX "User_createdAt_idx" ON public."User" USING btree ("createdAt");


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: _CourseLanguages_B_index; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX "_CourseLanguages_B_index" ON public."_CourseLanguages" USING btree ("B");


--
-- Name: _TrainerCourses_B_index; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX "_TrainerCourses_B_index" ON public."_TrainerCourses" USING btree ("B");


--
-- Name: _TrainerLanguages_B_index; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX "_TrainerLanguages_B_index" ON public."_TrainerLanguages" USING btree ("B");


--
-- Name: Course Course_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Course"
    ADD CONSTRAINT "Course_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Delegate Delegate_clientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Delegate"
    ADD CONSTRAINT "Delegate_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES public."Client"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Delegate Delegate_sessionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Delegate"
    ADD CONSTRAINT "Delegate_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES public."TrainingSession"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PasswordResetToken PasswordResetToken_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."PasswordResetToken"
    ADD CONSTRAINT "PasswordResetToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Room Room_locationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Room"
    ADD CONSTRAINT "Room_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES public."Location"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: TrainerLeave TrainerLeave_trainerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."TrainerLeave"
    ADD CONSTRAINT "TrainerLeave_trainerId_fkey" FOREIGN KEY ("trainerId") REFERENCES public."Trainer"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: TrainerSchedulingRule TrainerSchedulingRule_trainerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."TrainerSchedulingRule"
    ADD CONSTRAINT "TrainerSchedulingRule_trainerId_fkey" FOREIGN KEY ("trainerId") REFERENCES public."Trainer"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Trainer Trainer_locationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Trainer"
    ADD CONSTRAINT "Trainer_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES public."Location"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: TrainingSession TrainingSession_courseId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."TrainingSession"
    ADD CONSTRAINT "TrainingSession_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES public."Course"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: TrainingSession TrainingSession_locationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."TrainingSession"
    ADD CONSTRAINT "TrainingSession_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES public."Location"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: TrainingSession TrainingSession_roomId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."TrainingSession"
    ADD CONSTRAINT "TrainingSession_roomId_fkey" FOREIGN KEY ("roomId") REFERENCES public."Room"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: TrainingSession TrainingSession_trainerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."TrainingSession"
    ADD CONSTRAINT "TrainingSession_trainerId_fkey" FOREIGN KEY ("trainerId") REFERENCES public."Trainer"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: _CourseLanguages _CourseLanguages_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."_CourseLanguages"
    ADD CONSTRAINT "_CourseLanguages_A_fkey" FOREIGN KEY ("A") REFERENCES public."Course"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CourseLanguages _CourseLanguages_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."_CourseLanguages"
    ADD CONSTRAINT "_CourseLanguages_B_fkey" FOREIGN KEY ("B") REFERENCES public."Language"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _TrainerCourses _TrainerCourses_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."_TrainerCourses"
    ADD CONSTRAINT "_TrainerCourses_A_fkey" FOREIGN KEY ("A") REFERENCES public."Course"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _TrainerCourses _TrainerCourses_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."_TrainerCourses"
    ADD CONSTRAINT "_TrainerCourses_B_fkey" FOREIGN KEY ("B") REFERENCES public."Trainer"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _TrainerLanguages _TrainerLanguages_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."_TrainerLanguages"
    ADD CONSTRAINT "_TrainerLanguages_A_fkey" FOREIGN KEY ("A") REFERENCES public."Language"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _TrainerLanguages _TrainerLanguages_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."_TrainerLanguages"
    ADD CONSTRAINT "_TrainerLanguages_B_fkey" FOREIGN KEY ("B") REFERENCES public."Trainer"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: neondb_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO neon_superuser WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON TABLES TO neon_superuser WITH GRANT OPTION;


--
-- PostgreSQL database dump complete
--

