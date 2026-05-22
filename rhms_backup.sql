--
-- PostgreSQL database dump
--

\restrict bcc3yDr77oZYv0EmWhKAMfy2joh6V0OS9NMi0Uh7evBezlowq1AkqzwmEjW9RZe

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: attendance_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.attendance_status AS ENUM (
    'present',
    'absent',
    'late',
    'half_day',
    'on_leave'
);


ALTER TYPE public.attendance_status OWNER TO postgres;

--
-- Name: booking_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.booking_status AS ENUM (
    'pending',
    'confirmed',
    'cancelled',
    'completed'
);


ALTER TYPE public.booking_status OWNER TO postgres;

--
-- Name: hotel_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.hotel_status AS ENUM (
    'pending',
    'approved',
    'rejected',
    'suspended'
);


ALTER TYPE public.hotel_status OWNER TO postgres;

--
-- Name: notification_priority; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.notification_priority AS ENUM (
    'low',
    'medium',
    'high',
    'urgent',
    'info'
);


ALTER TYPE public.notification_priority OWNER TO postgres;

--
-- Name: payment_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_status AS ENUM (
    'pending',
    'paid',
    'failed',
    'refunded'
);


ALTER TYPE public.payment_status OWNER TO postgres;

--
-- Name: room_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.room_status AS ENUM (
    'available',
    'booked',
    'maintenance',
    'occupied'
);


ALTER TYPE public.room_status OWNER TO postgres;

--
-- Name: staff_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.staff_status AS ENUM (
    'active',
    'inactive',
    'on_leave'
);


ALTER TYPE public.staff_status OWNER TO postgres;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'rdb',
    'hotel_admin',
    'client',
    'employee',
    'super_admin'
);


ALTER TYPE public.user_role OWNER TO postgres;

--
-- Name: generate_booking_number(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_booking_number() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_number VARCHAR(50);
    current_date_str VARCHAR(8);
BEGIN
    current_date_str := TO_CHAR(CURRENT_DATE, 'YYYYMMDD');
    new_number := 'BKG' || current_date_str || LPAD(CAST(FLOOR(RANDOM() * 9999) AS TEXT), 4, '0');
    
    WHILE EXISTS (SELECT 1 FROM bookings WHERE booking_number = new_number) LOOP
        new_number := 'BKG' || current_date_str || LPAD(CAST(FLOOR(RANDOM() * 9999) AS TEXT), 4, '0');
    END LOOP;
    
    RETURN new_number;
END;
$$;


ALTER FUNCTION public.generate_booking_number() OWNER TO postgres;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_activity_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_activity_logs (
    log_id integer NOT NULL,
    admin_id integer,
    action character varying(255) NOT NULL,
    entity_type character varying(50),
    entity_id integer,
    details jsonb,
    ip_address character varying(45),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.admin_activity_logs OWNER TO postgres;

--
-- Name: admin_activity_logs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_activity_logs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_activity_logs_log_id_seq OWNER TO postgres;

--
-- Name: admin_activity_logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_activity_logs_log_id_seq OWNED BY public.admin_activity_logs.log_id;


--
-- Name: amenities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.amenities (
    amenity_id integer NOT NULL,
    amenity_name character varying(100) NOT NULL,
    icon_class character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.amenities OWNER TO postgres;

--
-- Name: amenities_amenity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.amenities_amenity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.amenities_amenity_id_seq OWNER TO postgres;

--
-- Name: amenities_amenity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.amenities_amenity_id_seq OWNED BY public.amenities.amenity_id;


--
-- Name: announcement_recipients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.announcement_recipients (
    recipient_id integer NOT NULL,
    announcement_id integer,
    user_id integer,
    read_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.announcement_recipients OWNER TO postgres;

--
-- Name: announcement_recipients_recipient_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.announcement_recipients_recipient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.announcement_recipients_recipient_id_seq OWNER TO postgres;

--
-- Name: announcement_recipients_recipient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.announcement_recipients_recipient_id_seq OWNED BY public.announcement_recipients.recipient_id;


--
-- Name: announcements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.announcements (
    announcement_id integer NOT NULL,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    priority character varying(50) DEFAULT 'info'::character varying,
    target_roles public.user_role[],
    created_by integer,
    sent_to_all boolean DEFAULT false,
    scheduled_for timestamp without time zone,
    expires_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    sent_to text
);


ALTER TABLE public.announcements OWNER TO postgres;

--
-- Name: announcements_announcement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.announcements_announcement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.announcements_announcement_id_seq OWNER TO postgres;

--
-- Name: announcements_announcement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.announcements_announcement_id_seq OWNED BY public.announcements.announcement_id;


--
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance (
    attendance_id integer NOT NULL,
    staff_id integer,
    date date NOT NULL,
    check_in_time time without time zone,
    check_out_time time without time zone,
    check_in_location character varying(255),
    check_out_location character varying(255),
    hours_worked numeric(5,2),
    overtime_hours numeric(5,2) DEFAULT 0,
    status public.attendance_status DEFAULT 'present'::public.attendance_status,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    note text
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendance_attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendance_attendance_id_seq OWNER TO postgres;

--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_attendance_id_seq OWNED BY public.attendance.attendance_id;


--
-- Name: bank_transfers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bank_transfers (
    transfer_id integer NOT NULL,
    payment_id integer,
    bank_name character varying(100),
    account_number character varying(100),
    account_holder character varying(255),
    transfer_reference character varying(255),
    proof_image_url text,
    confirmed_by integer,
    confirmed_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.bank_transfers OWNER TO postgres;

--
-- Name: bank_transfers_transfer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bank_transfers_transfer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bank_transfers_transfer_id_seq OWNER TO postgres;

--
-- Name: bank_transfers_transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bank_transfers_transfer_id_seq OWNED BY public.bank_transfers.transfer_id;


--
-- Name: booking_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking_history (
    history_id integer NOT NULL,
    booking_id integer,
    action character varying(50) NOT NULL,
    old_status character varying(50),
    new_status character varying(50),
    changed_by integer,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.booking_history OWNER TO postgres;

--
-- Name: booking_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.booking_history_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.booking_history_history_id_seq OWNER TO postgres;

--
-- Name: booking_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.booking_history_history_id_seq OWNED BY public.booking_history.history_id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    booking_id integer NOT NULL,
    booking_number character varying(50) NOT NULL,
    hotel_id integer,
    room_id integer,
    user_id integer,
    guest_name character varying(255) NOT NULL,
    guest_email character varying(255) NOT NULL,
    guest_phone character varying(50),
    guest_nid character varying(50),
    guest_nationality character varying(100),
    check_in_date date NOT NULL,
    check_out_date date NOT NULL,
    number_of_nights integer,
    number_of_guests integer DEFAULT 1,
    number_of_children integer DEFAULT 0,
    room_type character varying(50),
    special_requests text,
    total_amount numeric(10,2) DEFAULT 0,
    discount_amount numeric(10,2) DEFAULT 0,
    tax_amount numeric(10,2) DEFAULT 0,
    final_amount numeric(10,2) NOT NULL,
    currency character varying(3) DEFAULT 'RWF'::character varying,
    status public.booking_status DEFAULT 'pending'::public.booking_status,
    payment_status public.payment_status DEFAULT 'pending'::public.payment_status,
    payment_method character varying(50),
    payment_reference character varying(255),
    booking_source character varying(50),
    cancelled_by integer,
    cancellation_reason text,
    cancelled_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- Name: bookings_booking_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bookings_booking_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bookings_booking_id_seq OWNER TO postgres;

--
-- Name: bookings_booking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bookings_booking_id_seq OWNED BY public.bookings.booking_id;


--
-- Name: chat_conversations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_conversations (
    conversation_id integer NOT NULL,
    participant1_id integer,
    participant2_id integer,
    hotel_id integer,
    last_message text,
    last_message_time timestamp without time zone,
    unread_count_p1 integer DEFAULT 0,
    unread_count_p2 integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.chat_conversations OWNER TO postgres;

--
-- Name: chat_conversations_conversation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chat_conversations_conversation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chat_conversations_conversation_id_seq OWNER TO postgres;

--
-- Name: chat_conversations_conversation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chat_conversations_conversation_id_seq OWNED BY public.chat_conversations.conversation_id;


--
-- Name: chat_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_messages (
    message_id integer NOT NULL,
    sender_id integer,
    receiver_id integer,
    hotel_id integer,
    message text,
    attachment_url text,
    attachment_type character varying(50),
    is_read boolean DEFAULT false,
    read_at timestamp without time zone,
    is_deleted_sender boolean DEFAULT false,
    is_deleted_receiver boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.chat_messages OWNER TO postgres;

--
-- Name: chat_messages_message_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chat_messages_message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chat_messages_message_id_seq OWNER TO postgres;

--
-- Name: chat_messages_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chat_messages_message_id_seq OWNED BY public.chat_messages.message_id;


--
-- Name: dice_rolls; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dice_rolls (
    id integer NOT NULL,
    roll_value integer NOT NULL,
    session_id character varying(100) NOT NULL,
    simulation_batch character varying(100),
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dice_rolls OWNER TO postgres;

--
-- Name: dice_rolls_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dice_rolls_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dice_rolls_id_seq OWNER TO postgres;

--
-- Name: dice_rolls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dice_rolls_id_seq OWNED BY public.dice_rolls.id;


--
-- Name: email_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_logs (
    email_id integer NOT NULL,
    user_id integer,
    recipient_email character varying(255) NOT NULL,
    subject character varying(255),
    template_name character varying(100),
    status character varying(50),
    error_message text,
    sent_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.email_logs OWNER TO postgres;

--
-- Name: email_logs_email_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.email_logs_email_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.email_logs_email_id_seq OWNER TO postgres;

--
-- Name: email_logs_email_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.email_logs_email_id_seq OWNED BY public.email_logs.email_id;


--
-- Name: guest_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.guest_reviews (
    review_id integer NOT NULL,
    booking_id integer,
    hotel_id integer,
    user_id integer,
    rating integer,
    title character varying(255),
    comment text,
    response text,
    response_by integer,
    response_at timestamp without time zone,
    is_verified boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT guest_reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.guest_reviews OWNER TO postgres;

--
-- Name: guest_reviews_review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.guest_reviews_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.guest_reviews_review_id_seq OWNER TO postgres;

--
-- Name: guest_reviews_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.guest_reviews_review_id_seq OWNED BY public.guest_reviews.review_id;


--
-- Name: hotel_daily_metrics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotel_daily_metrics (
    metric_id integer NOT NULL,
    hotel_id integer,
    date date NOT NULL,
    occupancy_rate numeric(5,2),
    revenue numeric(12,2),
    bookings_count integer,
    check_ins integer,
    check_outs integer,
    cancelled_bookings integer,
    average_daily_rate numeric(10,2),
    revpar numeric(10,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.hotel_daily_metrics OWNER TO postgres;

--
-- Name: hotel_daily_metrics_metric_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hotel_daily_metrics_metric_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hotel_daily_metrics_metric_id_seq OWNER TO postgres;

--
-- Name: hotel_daily_metrics_metric_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hotel_daily_metrics_metric_id_seq OWNED BY public.hotel_daily_metrics.metric_id;


--
-- Name: hotel_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotel_documents (
    document_id integer NOT NULL,
    hotel_id integer,
    document_type character varying(50) NOT NULL,
    document_url text NOT NULL,
    file_name character varying(255),
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.hotel_documents OWNER TO postgres;

--
-- Name: hotel_documents_document_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hotel_documents_document_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hotel_documents_document_id_seq OWNER TO postgres;

--
-- Name: hotel_documents_document_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hotel_documents_document_id_seq OWNED BY public.hotel_documents.document_id;


--
-- Name: hotel_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotel_settings (
    setting_id integer NOT NULL,
    hotel_id integer,
    setting_key character varying(100) NOT NULL,
    setting_value text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.hotel_settings OWNER TO postgres;

--
-- Name: hotel_settings_setting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hotel_settings_setting_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hotel_settings_setting_id_seq OWNER TO postgres;

--
-- Name: hotel_settings_setting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hotel_settings_setting_id_seq OWNED BY public.hotel_settings.setting_id;


--
-- Name: hotels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotels (
    hotel_id integer NOT NULL,
    user_id integer,
    hotel_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(50),
    alternative_phone character varying(50),
    address text,
    city character varying(100),
    district character varying(100),
    province character varying(100),
    country character varying(100) DEFAULT 'Rwanda'::character varying,
    latitude numeric(10,8),
    longitude numeric(11,8),
    description text,
    website character varying(255),
    logo_url text,
    cover_image_url text,
    total_rooms integer DEFAULT 0,
    staff_count integer DEFAULT 0,
    star_rating integer,
    status public.hotel_status DEFAULT 'pending'::public.hotel_status,
    rejection_reason text,
    registration_number character varying(100),
    tax_id character varying(100),
    contact_person character varying(255),
    approved_by integer,
    approved_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT hotels_star_rating_check CHECK (((star_rating >= 1) AND (star_rating <= 5)))
);


ALTER TABLE public.hotels OWNER TO postgres;

--
-- Name: hotels_hotel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hotels_hotel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hotels_hotel_id_seq OWNER TO postgres;

--
-- Name: hotels_hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hotels_hotel_id_seq OWNED BY public.hotels.hotel_id;


--
-- Name: leave_balances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leave_balances (
    balance_id integer NOT NULL,
    staff_id integer,
    year integer NOT NULL,
    annual_leave_total numeric(5,2) DEFAULT 20,
    annual_leave_used numeric(5,2) DEFAULT 0,
    sick_leave_total numeric(5,2) DEFAULT 12,
    sick_leave_used numeric(5,2) DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.leave_balances OWNER TO postgres;

--
-- Name: leave_balances_balance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.leave_balances_balance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.leave_balances_balance_id_seq OWNER TO postgres;

--
-- Name: leave_balances_balance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.leave_balances_balance_id_seq OWNED BY public.leave_balances.balance_id;


--
-- Name: leaves; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leaves (
    leave_id integer NOT NULL,
    staff_id integer,
    leave_type character varying(50) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    reason text,
    status character varying(20) DEFAULT 'pending'::character varying,
    approved_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.leaves OWNER TO postgres;

--
-- Name: leaves_leave_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.leaves_leave_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.leaves_leave_id_seq OWNER TO postgres;

--
-- Name: leaves_leave_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.leaves_leave_id_seq OWNED BY public.leaves.leave_id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    message_id integer NOT NULL,
    sender_id integer NOT NULL,
    receiver_id integer NOT NULL,
    message text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_read boolean DEFAULT false,
    read_at timestamp without time zone,
    is_delivered boolean DEFAULT false,
    delivered_at timestamp without time zone,
    CONSTRAINT check_self_message CHECK ((sender_id <> receiver_id))
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: messages_message_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.messages_message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.messages_message_id_seq OWNER TO postgres;

--
-- Name: messages_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.messages_message_id_seq OWNED BY public.messages.message_id;


--
-- Name: mobile_money_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mobile_money_transactions (
    transaction_id integer NOT NULL,
    payment_id integer,
    provider character varying(50),
    phone_number character varying(20),
    request_id character varying(255),
    status character varying(50),
    response_data jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mobile_money_transactions OWNER TO postgres;

--
-- Name: mobile_money_transactions_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mobile_money_transactions_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mobile_money_transactions_transaction_id_seq OWNER TO postgres;

--
-- Name: mobile_money_transactions_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mobile_money_transactions_transaction_id_seq OWNED BY public.mobile_money_transactions.transaction_id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    notification_id integer NOT NULL,
    user_id integer,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    type character varying(50),
    priority character varying(50) DEFAULT 'medium'::character varying,
    is_read boolean DEFAULT false,
    read_at timestamp without time zone,
    action_url text,
    icon character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    hotel_id integer,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_notification_id_seq OWNER TO postgres;

--
-- Name: notifications_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_notification_id_seq OWNED BY public.notifications.notification_id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    payment_id integer NOT NULL,
    booking_id integer,
    user_id integer,
    amount numeric(10,2) NOT NULL,
    payment_method character varying(50),
    transaction_id character varying(255),
    payment_reference character varying(255),
    status public.payment_status DEFAULT 'pending'::public.payment_status,
    payment_date timestamp without time zone,
    payment_details jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_payment_id_seq OWNER TO postgres;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- Name: payroll_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payroll_logs (
    log_id integer NOT NULL,
    processed_by integer,
    month integer NOT NULL,
    year integer NOT NULL,
    total_amount numeric(12,2),
    status character varying(50),
    details jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.payroll_logs OWNER TO postgres;

--
-- Name: payroll_logs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payroll_logs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payroll_logs_log_id_seq OWNER TO postgres;

--
-- Name: payroll_logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payroll_logs_log_id_seq OWNED BY public.payroll_logs.log_id;


--
-- Name: probability_analyses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.probability_analyses (
    id integer NOT NULL,
    concept_name character varying(200) NOT NULL,
    analysis_type character varying(50) NOT NULL,
    sample_sizes json NOT NULL,
    probabilities json NOT NULL,
    error_rates json,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.probability_analyses OWNER TO postgres;

--
-- Name: probability_analyses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.probability_analyses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.probability_analyses_id_seq OWNER TO postgres;

--
-- Name: probability_analyses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.probability_analyses_id_seq OWNED BY public.probability_analyses.id;


--
-- Name: push_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.push_tokens (
    token_id integer NOT NULL,
    user_id integer,
    device_token text NOT NULL,
    device_type character varying(50),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.push_tokens OWNER TO postgres;

--
-- Name: push_tokens_token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.push_tokens_token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.push_tokens_token_id_seq OWNER TO postgres;

--
-- Name: push_tokens_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.push_tokens_token_id_seq OWNED BY public.push_tokens.token_id;


--
-- Name: rdb_admins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rdb_admins (
    admin_id integer NOT NULL,
    user_id integer,
    full_name character varying(255) NOT NULL,
    username character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    role character varying(50) DEFAULT 'admin'::character varying,
    department character varying(100),
    status character varying(50) DEFAULT 'active'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    password_hash character varying(255)
);


ALTER TABLE public.rdb_admins OWNER TO postgres;

--
-- Name: rdb_admins_admin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rdb_admins_admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rdb_admins_admin_id_seq OWNER TO postgres;

--
-- Name: rdb_admins_admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rdb_admins_admin_id_seq OWNED BY public.rdb_admins.admin_id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reports (
    report_id integer NOT NULL,
    staff_id integer,
    title character varying(200) NOT NULL,
    type character varying(50),
    period character varying(100),
    file_url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.reports OWNER TO postgres;

--
-- Name: reports_report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reports_report_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reports_report_id_seq OWNER TO postgres;

--
-- Name: reports_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reports_report_id_seq OWNED BY public.reports.report_id;


--
-- Name: room_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.room_images (
    image_id integer NOT NULL,
    room_id integer,
    image_url text NOT NULL,
    is_primary boolean DEFAULT false,
    caption character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.room_images OWNER TO postgres;

--
-- Name: room_images_image_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.room_images_image_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.room_images_image_id_seq OWNER TO postgres;

--
-- Name: room_images_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.room_images_image_id_seq OWNED BY public.room_images.image_id;


--
-- Name: room_pricing_seasons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.room_pricing_seasons (
    pricing_id integer NOT NULL,
    room_id integer,
    season_name character varying(100) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    price_multiplier numeric(3,2) DEFAULT 1.00,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.room_pricing_seasons OWNER TO postgres;

--
-- Name: room_pricing_seasons_pricing_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.room_pricing_seasons_pricing_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.room_pricing_seasons_pricing_id_seq OWNER TO postgres;

--
-- Name: room_pricing_seasons_pricing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.room_pricing_seasons_pricing_id_seq OWNED BY public.room_pricing_seasons.pricing_id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rooms (
    room_id integer NOT NULL,
    hotel_id integer,
    room_number character varying(20) NOT NULL,
    room_type character varying(50) NOT NULL,
    floor integer,
    capacity integer DEFAULT 2,
    extra_bed_capacity integer DEFAULT 0,
    price_per_night numeric(10,2) NOT NULL,
    weekend_price numeric(10,2),
    holiday_price numeric(10,2),
    status public.room_status DEFAULT 'available'::public.room_status,
    amenities text[],
    description text,
    images text[],
    maintenance_reason text,
    maintenance_start_date date,
    maintenance_end_date date,
    is_featured boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.rooms OWNER TO postgres;

--
-- Name: rooms_room_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rooms_room_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rooms_room_id_seq OWNER TO postgres;

--
-- Name: rooms_room_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rooms_room_id_seq OWNED BY public.rooms.room_id;


--
-- Name: salary_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.salary_records (
    salary_id integer NOT NULL,
    staff_id integer NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    base_salary numeric(10,2) DEFAULT 0,
    overtime_pay numeric(10,2) DEFAULT 0,
    bonus numeric(10,2) DEFAULT 0,
    commission numeric(10,2) DEFAULT 0,
    allowances numeric(10,2) DEFAULT 0,
    deductions_tax numeric(10,2) DEFAULT 0,
    deductions_insurance numeric(10,2) DEFAULT 0,
    deductions_other numeric(10,2) DEFAULT 0,
    net_salary numeric(10,2) DEFAULT 0,
    status character varying(20) DEFAULT 'Pending'::character varying,
    payment_date date,
    payment_reference character varying(100),
    processed_by integer,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.salary_records OWNER TO postgres;

--
-- Name: salary_records_salary_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.salary_records_salary_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.salary_records_salary_id_seq OWNER TO postgres;

--
-- Name: salary_records_salary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.salary_records_salary_id_seq OWNED BY public.salary_records.salary_id;


--
-- Name: simulation_batches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.simulation_batches (
    id integer NOT NULL,
    batch_id character varying(100) NOT NULL,
    concept_name character varying(200) NOT NULL,
    total_trials integer NOT NULL,
    num_simulations integer DEFAULT 1,
    avg_experimental_prob numeric(10,6),
    std_deviation numeric(10,6),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.simulation_batches OWNER TO postgres;

--
-- Name: simulation_batches_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.simulation_batches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.simulation_batches_id_seq OWNER TO postgres;

--
-- Name: simulation_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.simulation_batches_id_seq OWNED BY public.simulation_batches.id;


--
-- Name: simulation_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.simulation_results (
    id integer NOT NULL,
    concept_name character varying(200) NOT NULL,
    concept_category character varying(100),
    theoretical_prob numeric(10,6) NOT NULL,
    experimental_prob numeric(10,6) NOT NULL,
    num_trials integer NOT NULL,
    additional_data json,
    user_session_id character varying(100),
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.simulation_results OWNER TO postgres;

--
-- Name: simulation_results_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.simulation_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.simulation_results_id_seq OWNER TO postgres;

--
-- Name: simulation_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.simulation_results_id_seq OWNED BY public.simulation_results.id;


--
-- Name: staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff (
    staff_id integer NOT NULL,
    hotel_id integer,
    user_id integer,
    full_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(50),
    nid character varying(50),
    role character varying(100),
    department character varying(100),
    position_level character varying(50),
    salary numeric(10,2),
    hourly_rate numeric(10,2),
    shift character varying(50),
    shift_start time without time zone,
    shift_end time without time zone,
    emergency_contact_name character varying(255),
    emergency_contact_phone character varying(50),
    address text,
    joined_date date,
    status public.staff_status DEFAULT 'active'::public.staff_status,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.staff OWNER TO postgres;

--
-- Name: staff_leave_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff_leave_requests (
    leave_id integer NOT NULL,
    staff_id integer,
    leave_type character varying(50) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    reason text,
    status character varying(50) DEFAULT 'pending'::character varying,
    approved_by integer,
    approved_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.staff_leave_requests OWNER TO postgres;

--
-- Name: staff_leave_requests_leave_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_leave_requests_leave_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_leave_requests_leave_id_seq OWNER TO postgres;

--
-- Name: staff_leave_requests_leave_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_leave_requests_leave_id_seq OWNED BY public.staff_leave_requests.leave_id;


--
-- Name: staff_performance_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff_performance_reviews (
    review_id integer NOT NULL,
    staff_id integer,
    reviewer_id integer,
    review_date date NOT NULL,
    rating integer,
    comments text,
    goals text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT staff_performance_reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.staff_performance_reviews OWNER TO postgres;

--
-- Name: staff_performance_reviews_review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_performance_reviews_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_performance_reviews_review_id_seq OWNER TO postgres;

--
-- Name: staff_performance_reviews_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_performance_reviews_review_id_seq OWNED BY public.staff_performance_reviews.review_id;


--
-- Name: staff_staff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_staff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_staff_id_seq OWNER TO postgres;

--
-- Name: staff_staff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_staff_id_seq OWNED BY public.staff.staff_id;


--
-- Name: system_reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_reports (
    report_id integer NOT NULL,
    report_name character varying(255) NOT NULL,
    report_type character varying(100),
    generated_by integer,
    parameters jsonb,
    file_url text,
    status character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.system_reports OWNER TO postgres;

--
-- Name: system_reports_report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.system_reports_report_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_reports_report_id_seq OWNER TO postgres;

--
-- Name: system_reports_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.system_reports_report_id_seq OWNED BY public.system_reports.report_id;


--
-- Name: system_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_settings (
    setting_id integer NOT NULL,
    setting_key character varying(100) NOT NULL,
    setting_value text,
    setting_group character varying(50),
    description text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.system_settings OWNER TO postgres;

--
-- Name: system_settings_setting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.system_settings_setting_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_settings_setting_id_seq OWNER TO postgres;

--
-- Name: system_settings_setting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.system_settings_setting_id_seq OWNED BY public.system_settings.setting_id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    task_id integer NOT NULL,
    assigned_to integer,
    assigned_by integer,
    title character varying(255) NOT NULL,
    description text,
    priority character varying(20) DEFAULT 'medium'::character varying,
    status character varying(20) DEFAULT 'pending'::character varying,
    due_date date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    completed_at timestamp without time zone
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- Name: tasks_task_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasks_task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasks_task_id_seq OWNER TO postgres;

--
-- Name: tasks_task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasks_task_id_seq OWNED BY public.tasks.task_id;


--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_sessions (
    session_id integer NOT NULL,
    user_id integer,
    token character varying(500) NOT NULL,
    ip_address character varying(45),
    user_agent text,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_sessions OWNER TO postgres;

--
-- Name: user_sessions_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_sessions_session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_sessions_session_id_seq OWNER TO postgres;

--
-- Name: user_sessions_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_sessions_session_id_seq OWNED BY public.user_sessions.session_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(50),
    password_hash character varying(255) NOT NULL,
    role character varying(50) NOT NULL,
    is_verified boolean DEFAULT false,
    verification_code character varying(6),
    verification_code_expires timestamp without time zone,
    reset_token character varying(255),
    reset_token_expires timestamp without time zone,
    two_factor_enabled boolean DEFAULT false,
    two_factor_secret character varying(255),
    profile_picture text,
    last_login timestamp without time zone,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: admin_activity_logs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_activity_logs ALTER COLUMN log_id SET DEFAULT nextval('public.admin_activity_logs_log_id_seq'::regclass);


--
-- Name: amenities amenity_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amenities ALTER COLUMN amenity_id SET DEFAULT nextval('public.amenities_amenity_id_seq'::regclass);


--
-- Name: announcement_recipients recipient_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcement_recipients ALTER COLUMN recipient_id SET DEFAULT nextval('public.announcement_recipients_recipient_id_seq'::regclass);


--
-- Name: announcements announcement_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements ALTER COLUMN announcement_id SET DEFAULT nextval('public.announcements_announcement_id_seq'::regclass);


--
-- Name: attendance attendance_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance ALTER COLUMN attendance_id SET DEFAULT nextval('public.attendance_attendance_id_seq'::regclass);


--
-- Name: bank_transfers transfer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_transfers ALTER COLUMN transfer_id SET DEFAULT nextval('public.bank_transfers_transfer_id_seq'::regclass);


--
-- Name: booking_history history_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_history ALTER COLUMN history_id SET DEFAULT nextval('public.booking_history_history_id_seq'::regclass);


--
-- Name: bookings booking_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings ALTER COLUMN booking_id SET DEFAULT nextval('public.bookings_booking_id_seq'::regclass);


--
-- Name: chat_conversations conversation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_conversations ALTER COLUMN conversation_id SET DEFAULT nextval('public.chat_conversations_conversation_id_seq'::regclass);


--
-- Name: chat_messages message_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages ALTER COLUMN message_id SET DEFAULT nextval('public.chat_messages_message_id_seq'::regclass);


--
-- Name: dice_rolls id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dice_rolls ALTER COLUMN id SET DEFAULT nextval('public.dice_rolls_id_seq'::regclass);


--
-- Name: email_logs email_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_logs ALTER COLUMN email_id SET DEFAULT nextval('public.email_logs_email_id_seq'::regclass);


--
-- Name: guest_reviews review_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guest_reviews ALTER COLUMN review_id SET DEFAULT nextval('public.guest_reviews_review_id_seq'::regclass);


--
-- Name: hotel_daily_metrics metric_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_daily_metrics ALTER COLUMN metric_id SET DEFAULT nextval('public.hotel_daily_metrics_metric_id_seq'::regclass);


--
-- Name: hotel_documents document_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_documents ALTER COLUMN document_id SET DEFAULT nextval('public.hotel_documents_document_id_seq'::regclass);


--
-- Name: hotel_settings setting_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_settings ALTER COLUMN setting_id SET DEFAULT nextval('public.hotel_settings_setting_id_seq'::regclass);


--
-- Name: hotels hotel_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels ALTER COLUMN hotel_id SET DEFAULT nextval('public.hotels_hotel_id_seq'::regclass);


--
-- Name: leave_balances balance_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_balances ALTER COLUMN balance_id SET DEFAULT nextval('public.leave_balances_balance_id_seq'::regclass);


--
-- Name: leaves leave_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leaves ALTER COLUMN leave_id SET DEFAULT nextval('public.leaves_leave_id_seq'::regclass);


--
-- Name: messages message_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages ALTER COLUMN message_id SET DEFAULT nextval('public.messages_message_id_seq'::regclass);


--
-- Name: mobile_money_transactions transaction_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mobile_money_transactions ALTER COLUMN transaction_id SET DEFAULT nextval('public.mobile_money_transactions_transaction_id_seq'::regclass);


--
-- Name: notifications notification_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN notification_id SET DEFAULT nextval('public.notifications_notification_id_seq'::regclass);


--
-- Name: payments payment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- Name: payroll_logs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payroll_logs ALTER COLUMN log_id SET DEFAULT nextval('public.payroll_logs_log_id_seq'::regclass);


--
-- Name: probability_analyses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.probability_analyses ALTER COLUMN id SET DEFAULT nextval('public.probability_analyses_id_seq'::regclass);


--
-- Name: push_tokens token_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.push_tokens ALTER COLUMN token_id SET DEFAULT nextval('public.push_tokens_token_id_seq'::regclass);


--
-- Name: rdb_admins admin_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rdb_admins ALTER COLUMN admin_id SET DEFAULT nextval('public.rdb_admins_admin_id_seq'::regclass);


--
-- Name: reports report_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports ALTER COLUMN report_id SET DEFAULT nextval('public.reports_report_id_seq'::regclass);


--
-- Name: room_images image_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room_images ALTER COLUMN image_id SET DEFAULT nextval('public.room_images_image_id_seq'::regclass);


--
-- Name: room_pricing_seasons pricing_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room_pricing_seasons ALTER COLUMN pricing_id SET DEFAULT nextval('public.room_pricing_seasons_pricing_id_seq'::regclass);


--
-- Name: rooms room_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms ALTER COLUMN room_id SET DEFAULT nextval('public.rooms_room_id_seq'::regclass);


--
-- Name: salary_records salary_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salary_records ALTER COLUMN salary_id SET DEFAULT nextval('public.salary_records_salary_id_seq'::regclass);


--
-- Name: simulation_batches id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.simulation_batches ALTER COLUMN id SET DEFAULT nextval('public.simulation_batches_id_seq'::regclass);


--
-- Name: simulation_results id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.simulation_results ALTER COLUMN id SET DEFAULT nextval('public.simulation_results_id_seq'::regclass);


--
-- Name: staff staff_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff ALTER COLUMN staff_id SET DEFAULT nextval('public.staff_staff_id_seq'::regclass);


--
-- Name: staff_leave_requests leave_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_leave_requests ALTER COLUMN leave_id SET DEFAULT nextval('public.staff_leave_requests_leave_id_seq'::regclass);


--
-- Name: staff_performance_reviews review_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_performance_reviews ALTER COLUMN review_id SET DEFAULT nextval('public.staff_performance_reviews_review_id_seq'::regclass);


--
-- Name: system_reports report_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_reports ALTER COLUMN report_id SET DEFAULT nextval('public.system_reports_report_id_seq'::regclass);


--
-- Name: system_settings setting_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings ALTER COLUMN setting_id SET DEFAULT nextval('public.system_settings_setting_id_seq'::regclass);


--
-- Name: tasks task_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks ALTER COLUMN task_id SET DEFAULT nextval('public.tasks_task_id_seq'::regclass);


--
-- Name: user_sessions session_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sessions ALTER COLUMN session_id SET DEFAULT nextval('public.user_sessions_session_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: admin_activity_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin_activity_logs (log_id, admin_id, action, entity_type, entity_id, details, ip_address, created_at) FROM stdin;
\.


--
-- Data for Name: amenities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.amenities (amenity_id, amenity_name, icon_class, created_at) FROM stdin;
1	Free WiFi	fa-wifi	2026-05-12 22:36:44.567525
2	Air Conditioning	fa-wind	2026-05-12 22:36:44.567525
3	Restaurant	fa-utensils	2026-05-12 22:36:44.567525
4	Swimming Pool	fa-swimmer	2026-05-12 22:36:44.567525
5	Parking	fa-parking	2026-05-12 22:36:44.567525
6	Spa	fa-spa	2026-05-12 22:36:44.567525
7	Gym	fa-dumbbell	2026-05-12 22:36:44.567525
8	Room Service	fa-concierge-bell	2026-05-12 22:36:44.567525
9	Bar	fa-cocktail	2026-05-12 22:36:44.567525
10	Business Center	fa-briefcase	2026-05-12 22:36:44.567525
11	Conference Room	fa-chalkboard	2026-05-12 22:36:44.567525
12	Airport Shuttle	fa-shuttle-van	2026-05-12 22:36:44.567525
13	Laundry Service	fa-tshirt	2026-05-12 22:36:44.567525
14	24/7 Front Desk	fa-clock	2026-05-12 22:36:44.567525
15	Pet Friendly	fa-paw	2026-05-12 22:36:44.567525
\.


--
-- Data for Name: announcement_recipients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.announcement_recipients (recipient_id, announcement_id, user_id, read_at, created_at) FROM stdin;
\.


--
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.announcements (announcement_id, title, message, priority, target_roles, created_by, sent_to_all, scheduled_for, expires_at, created_at, sent_to) FROM stdin;
2	RWANDA	Welcome to rwanda  hotel management system	info	\N	11	f	\N	\N	2026-05-16 14:20:14.250429	Sent to 1 hotels on 5/16/2026, 2:20:14 PM
3	kumenyesha	muraho neza, uyumunsi dufite  gusura hotel zose	urgent	\N	11	f	\N	\N	2026-05-20 15:58:33.149726	Sent to 2 hotels on 5/20/2026, 3:58:33 PM
4	kumenyesha	muraho neza, uyumunsi dufite  gusura hotel zose	urgent	\N	11	f	\N	\N	2026-05-20 16:18:49.426721	Sent to 2 hotels on 5/20/2026, 4:18:49 PM
\.


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (attendance_id, staff_id, date, check_in_time, check_out_time, check_in_location, check_out_location, hours_worked, overtime_hours, status, notes, created_at, updated_at, note) FROM stdin;
1	2	2026-05-20	\N	\N	\N	\N	\N	0.00	present	\N	2026-05-20 15:28:36.726192	2026-05-20 15:32:26.468016	\N
2	2	2025-12-01	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
3	2	2025-12-02	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
4	2	2025-12-03	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
5	2	2025-12-04	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
6	2	2025-12-05	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
7	2	2025-12-06	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
8	2	2025-12-07	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
9	2	2025-12-08	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
10	2	2025-12-09	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
11	2	2025-12-10	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
12	2	2025-12-11	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
13	2	2025-12-12	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
14	2	2025-12-13	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
15	2	2025-12-14	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
16	2	2025-12-15	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
17	2	2025-12-16	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
18	2	2025-12-17	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
19	2	2025-12-18	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
20	2	2025-12-19	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
21	2	2025-12-20	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
22	2	2025-12-21	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
23	2	2025-12-22	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
24	2	2025-12-23	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
25	2	2025-12-24	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
26	2	2025-12-25	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
27	2	2025-12-26	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
28	2	2025-12-27	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
29	2	2025-12-28	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
30	2	2025-12-29	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
31	2	2025-12-30	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
32	2	2025-12-31	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
33	2	2026-01-01	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
34	2	2026-01-02	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
35	2	2026-01-03	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
36	2	2026-01-04	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
37	2	2026-01-05	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
38	2	2026-01-06	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
39	2	2026-01-07	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
40	2	2026-01-08	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
41	2	2026-01-09	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
42	2	2026-01-10	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
43	2	2026-01-11	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
44	2	2026-01-12	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
45	2	2026-01-13	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
46	2	2026-01-14	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
47	2	2026-01-15	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
48	2	2026-01-16	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
49	2	2026-01-17	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
50	2	2026-01-18	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
51	2	2026-01-19	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
52	2	2026-01-20	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
53	2	2026-01-21	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
54	2	2026-01-22	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
55	2	2026-01-23	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
56	2	2026-01-24	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
57	2	2026-01-25	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
58	2	2026-01-26	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
59	2	2026-01-27	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
60	2	2026-01-28	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
61	2	2026-01-29	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
62	2	2026-01-30	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
63	2	2026-01-31	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
64	2	2026-02-01	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
65	2	2026-02-02	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
66	2	2026-02-03	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
67	2	2026-02-04	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
68	2	2026-02-05	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
69	2	2026-02-06	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
70	2	2026-02-07	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
71	2	2026-02-08	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
72	2	2026-02-09	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
73	2	2026-02-10	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
74	2	2026-02-11	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
75	2	2026-02-12	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
76	2	2026-02-13	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
77	2	2026-02-14	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
78	2	2026-02-15	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
79	2	2026-02-16	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
80	2	2026-02-17	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
81	2	2026-02-18	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
82	2	2026-02-19	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
83	2	2026-02-20	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
84	2	2026-02-21	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
85	2	2026-02-22	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
86	2	2026-02-23	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
87	2	2026-02-24	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
88	2	2026-02-25	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
89	2	2026-02-26	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
90	2	2026-02-27	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
91	2	2026-02-28	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
92	2	2026-03-01	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
93	2	2026-03-02	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
94	2	2026-03-03	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
95	2	2026-03-04	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
96	2	2026-03-05	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
97	2	2026-03-06	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
98	2	2026-03-07	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
99	2	2026-03-08	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
100	2	2026-03-09	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
101	2	2026-03-10	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
102	2	2026-03-11	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
103	2	2026-03-12	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
104	2	2026-03-13	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
105	2	2026-03-14	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
106	2	2026-03-15	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
107	2	2026-03-16	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
108	2	2026-03-17	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
109	2	2026-03-18	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
110	2	2026-03-19	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
111	2	2026-03-20	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
112	2	2026-03-21	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
113	2	2026-03-22	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
114	2	2026-03-23	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
115	2	2026-03-24	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
116	2	2026-03-25	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
117	2	2026-03-26	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
118	2	2026-03-27	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
119	2	2026-03-28	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
120	2	2026-03-29	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
121	2	2026-03-30	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
122	2	2026-03-31	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
123	2	2026-04-01	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
124	2	2026-04-02	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
125	2	2026-04-03	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
126	2	2026-04-04	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
127	2	2026-04-05	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
128	2	2026-04-06	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
129	2	2026-04-07	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
130	2	2026-04-08	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
131	2	2026-04-09	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
132	2	2026-04-10	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
133	2	2026-04-11	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
134	2	2026-04-12	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
135	2	2026-04-13	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
136	2	2026-04-14	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
137	2	2026-04-15	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
138	2	2026-04-16	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
139	2	2026-04-17	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
140	2	2026-04-18	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
141	2	2026-04-19	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
142	2	2026-04-20	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
143	2	2026-04-21	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
144	2	2026-04-22	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
145	2	2026-04-23	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
146	2	2026-04-24	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
147	2	2026-04-25	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
148	2	2026-04-26	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
149	2	2026-04-27	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
150	2	2026-04-28	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
151	2	2026-04-29	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
152	2	2026-04-30	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
153	2	2026-05-01	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
154	2	2026-05-02	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
155	2	2026-05-03	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
156	2	2026-05-04	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
157	2	2026-05-05	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
158	2	2026-05-06	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
159	2	2026-05-07	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
160	2	2026-05-08	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
161	2	2026-05-09	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
162	2	2026-05-10	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
163	2	2026-05-11	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
164	2	2026-05-12	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
165	2	2026-05-13	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
166	2	2026-05-14	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
167	2	2026-05-15	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
168	2	2026-05-16	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
169	2	2026-05-17	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
170	2	2026-05-18	09:00:00	17:00:00	\N	\N	8.00	0.00	absent	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
171	2	2026-05-19	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
173	2	2026-05-21	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 19:50:58.444718	2026-05-21 19:50:58.444718	\N
174	1	2026-05-21	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 20:02:18.066116	2026-05-21 20:02:18.066116	\N
175	1	2026-05-20	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 20:02:18.066116	2026-05-21 20:02:18.066116	\N
176	1	2026-05-19	09:30:00	17:00:00	\N	\N	7.50	0.00	late	\N	2026-05-21 20:02:18.066116	2026-05-21 20:02:18.066116	\N
177	1	2026-05-18	09:00:00	17:00:00	\N	\N	8.00	0.00	present	\N	2026-05-21 20:02:18.066116	2026-05-21 20:02:18.066116	\N
178	1	2026-05-17	\N	\N	\N	\N	0.00	0.00	absent	\N	2026-05-21 20:02:18.066116	2026-05-21 20:02:18.066116	\N
\.


--
-- Data for Name: bank_transfers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bank_transfers (transfer_id, payment_id, bank_name, account_number, account_holder, transfer_reference, proof_image_url, confirmed_by, confirmed_at, created_at) FROM stdin;
\.


--
-- Data for Name: booking_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.booking_history (history_id, booking_id, action, old_status, new_status, changed_by, notes, created_at) FROM stdin;
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (booking_id, booking_number, hotel_id, room_id, user_id, guest_name, guest_email, guest_phone, guest_nid, guest_nationality, check_in_date, check_out_date, number_of_nights, number_of_guests, number_of_children, room_type, special_requests, total_amount, discount_amount, tax_amount, final_amount, currency, status, payment_status, payment_method, payment_reference, booking_source, cancelled_by, cancellation_reason, cancelled_at, created_at, updated_at) FROM stdin;
3	BKG1779303583324678	1	3	1	Lucie Niyonkuru	lucieniyonkuru46@gmail.com	0791970956	\N	\N	2026-05-22	2026-05-25	3	2	0	Executive		0.00	0.00	0.00	3000000.00	RWF	confirmed	pending	\N	\N	\N	\N	\N	\N	2026-05-20 20:59:43.325593	2026-05-20 22:55:25.239788
\.


--
-- Data for Name: chat_conversations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_conversations (conversation_id, participant1_id, participant2_id, hotel_id, last_message, last_message_time, unread_count_p1, unread_count_p2, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: chat_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_messages (message_id, sender_id, receiver_id, hotel_id, message, attachment_url, attachment_type, is_read, read_at, is_deleted_sender, is_deleted_receiver, created_at) FROM stdin;
1	16	1	\N	heloo	\N	\N	f	\N	f	f	2026-05-20 14:18:25.998937
2	16	1	\N	i have a question	\N	\N	f	\N	f	f	2026-05-20 14:18:48.406441
3	16	1	\N	i was not receive my salary of January?	\N	\N	f	\N	f	f	2026-05-20 14:19:40.817187
4	16	1	\N	hello	\N	\N	f	\N	f	f	2026-05-20 14:30:37.83738
5	16	1	\N	how are you?	\N	\N	f	\N	f	f	2026-05-20 14:30:54.980908
6	16	1	\N	my name is oscar	\N	\N	f	\N	f	f	2026-05-20 14:31:13.175587
7	16	1	\N	which is task for to day?	\N	\N	f	\N	f	f	2026-05-20 14:31:38.452766
8	16	1	\N	tyrueiw	\N	\N	f	\N	f	f	2026-05-20 14:31:43.416915
9	16	1	\N	ntabwo namubonye	\N	\N	f	\N	f	f	2026-05-20 14:31:57.935485
10	16	1	\N	good	\N	\N	f	\N	f	f	2026-05-20 15:41:54.99542
11	1	2	\N	hello	\N	\N	f	\N	f	f	2026-05-20 21:06:09.923004
12	1	2	\N	thank you so much!!	\N	\N	f	\N	f	f	2026-05-20 23:04:18.574892
13	1	2	\N	hello	\N	\N	f	\N	f	f	2026-05-21 22:56:44.423174
\.


--
-- Data for Name: dice_rolls; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dice_rolls (id, roll_value, session_id, simulation_batch, "timestamp") FROM stdin;
\.


--
-- Data for Name: email_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_logs (email_id, user_id, recipient_email, subject, template_name, status, error_message, sent_at) FROM stdin;
\.


--
-- Data for Name: guest_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.guest_reviews (review_id, booking_id, hotel_id, user_id, rating, title, comment, response, response_by, response_at, is_verified, created_at) FROM stdin;
\.


--
-- Data for Name: hotel_daily_metrics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hotel_daily_metrics (metric_id, hotel_id, date, occupancy_rate, revenue, bookings_count, check_ins, check_outs, cancelled_bookings, average_daily_rate, revpar, created_at) FROM stdin;
\.


--
-- Data for Name: hotel_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hotel_documents (document_id, hotel_id, document_type, document_url, file_name, uploaded_at) FROM stdin;
\.


--
-- Data for Name: hotel_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hotel_settings (setting_id, hotel_id, setting_key, setting_value, updated_at) FROM stdin;
\.


--
-- Data for Name: hotels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hotels (hotel_id, user_id, hotel_name, email, phone, alternative_phone, address, city, district, province, country, latitude, longitude, description, website, logo_url, cover_image_url, total_rooms, staff_count, star_rating, status, rejection_reason, registration_number, tax_id, contact_person, approved_by, approved_at, created_at, updated_at) FROM stdin;
3	14	Neza	ndatimanaizabayo00@gmail.com	567483947	\N	Nyakabuye sectors,Rusizi districts\nWestern provence, RWANDA county	Kigali	\N	\N	Rwanda	\N	\N	\N	\N	\N	\N	0	0	\N	pending	\N			Mr oscar Mr oscar hagenimana	\N	\N	2026-05-18 00:21:49.262364	2026-05-18 00:21:49.262364
2	13	ihumure	hagenimanaoscar4@gmail.com	567584930	\N	GW84+Q5R\nUnnamed Road	Kigali	\N	\N	Rwanda	\N	\N	\N	\N	\N	\N	0	0	\N	approved	\N			Hagenimana Oscar	\N	\N	2026-05-18 00:08:30.996732	2026-05-19 19:19:36.886608
1	2	UMUNEZERO Hotel	hagenimanaoscar43@gmail.com	782398790	\N	kayonza ,rukara,kibirizi,video\nRusizi,Nyakabuye,Kamanu,Bugumya	Musanze	\N	\N	Rwanda	\N	\N	\N	\N	\N	\N	1	1	\N	approved	\N	123456	3456743221	Hagenimana Oscar	11	2026-05-19 18:26:18.519475	2026-05-13 08:48:38.483336	2026-05-19 21:10:01.602854
4	15	gahini	computersciences2025@gmail.com	567483475	\N	Nyakabuye sectors,Rusizi districts\nWestern provence, RWANDA county	Kigali	\N	\N	Rwanda	\N	\N	\N	\N	\N	\N	0	0	\N	approved	\N			Emelyne	\N	\N	2026-05-19 19:51:05.408265	2026-05-22 01:39:22.121697
\.


--
-- Data for Name: leave_balances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leave_balances (balance_id, staff_id, year, annual_leave_total, annual_leave_used, sick_leave_total, sick_leave_used, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: leaves; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leaves (leave_id, staff_id, leave_type, start_date, end_date, reason, status, approved_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (message_id, sender_id, receiver_id, message, created_at, is_read, read_at, is_delivered, delivered_at) FROM stdin;
\.


--
-- Data for Name: mobile_money_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mobile_money_transactions (transaction_id, payment_id, provider, phone_number, request_id, status, response_data, created_at) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (notification_id, user_id, title, message, type, priority, is_read, read_at, action_url, icon, created_at, hotel_id, updated_at) FROM stdin;
1	\N	kumenyesha	muraho neza, uyumunsi dufite  gusura hotel zose	announcement	urgent	f	\N	\N	\N	2026-05-20 16:18:49.438341	1	2026-05-20 16:18:49.438341
2	\N	kumenyesha	muraho neza, uyumunsi dufite  gusura hotel zose	announcement	urgent	f	\N	\N	\N	2026-05-20 16:18:49.453248	2	2026-05-20 16:18:49.453248
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (payment_id, booking_id, user_id, amount, payment_method, transaction_id, payment_reference, status, payment_date, payment_details, created_at) FROM stdin;
\.


--
-- Data for Name: payroll_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payroll_logs (log_id, processed_by, month, year, total_amount, status, details, created_at) FROM stdin;
\.


--
-- Data for Name: probability_analyses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.probability_analyses (id, concept_name, analysis_type, sample_sizes, probabilities, error_rates, created_at) FROM stdin;
\.


--
-- Data for Name: push_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.push_tokens (token_id, user_id, device_token, device_type, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: rdb_admins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rdb_admins (admin_id, user_id, full_name, username, email, role, department, status, created_at, updated_at, password_hash) FROM stdin;
9	11	RDB Administrator	rdb_admin	admin@rdb.gov.rw	super_admin	Hotel Regulation	active	2026-05-14 22:10:04.389554	2026-05-14 22:10:04.389554	\N
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reports (report_id, staff_id, title, type, period, file_url, created_at) FROM stdin;
\.


--
-- Data for Name: room_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.room_images (image_id, room_id, image_url, is_primary, caption, created_at) FROM stdin;
\.


--
-- Data for Name: room_pricing_seasons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.room_pricing_seasons (pricing_id, room_id, season_name, start_date, end_date, price_multiplier, created_at) FROM stdin;
\.


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rooms (room_id, hotel_id, room_number, room_type, floor, capacity, extra_bed_capacity, price_per_night, weekend_price, holiday_price, status, amenities, description, images, maintenance_reason, maintenance_start_date, maintenance_end_date, is_featured, created_at, updated_at) FROM stdin;
3	1	101	Executive	1	2	0	1000000.00	\N	\N	booked	{WiFi,TV,AC}	all facilities	\N	\N	\N	\N	f	2026-05-19 20:28:02.784808	2026-05-20 20:59:43.355191
\.


--
-- Data for Name: salary_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.salary_records (salary_id, staff_id, month, year, base_salary, overtime_pay, bonus, commission, allowances, deductions_tax, deductions_insurance, deductions_other, net_salary, status, payment_date, payment_reference, processed_by, notes, created_at, updated_at) FROM stdin;
1	2	5	2026	350000.00	0.00	13000.00	9999.00	0.00	0.00	0.00	0.00	\N	Paid	2026-05-20	PAY-202605-2	\N	\N	2026-05-20 18:07:11.61909	2026-05-20 18:08:07.966304
\.


--
-- Data for Name: simulation_batches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.simulation_batches (id, batch_id, concept_name, total_trials, num_simulations, avg_experimental_prob, std_deviation, created_at) FROM stdin;
\.


--
-- Data for Name: simulation_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.simulation_results (id, concept_name, concept_category, theoretical_prob, experimental_prob, num_trials, additional_data, user_session_id, "timestamp") FROM stdin;
\.


--
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff (staff_id, hotel_id, user_id, full_name, email, phone, nid, role, department, position_level, salary, hourly_rate, shift, shift_start, shift_end, emergency_contact_name, emergency_contact_phone, address, joined_date, status, created_at, updated_at) FROM stdin;
1	3	\N	John Employee	employee@hotel.com	0788123456	\N	Front Desk	Front Office	\N	350000.00	\N	\N	08:00:00	17:00:00	\N	\N	\N	\N	active	2026-05-19 20:53:52.061811	2026-05-19 20:53:52.061811
2	1	16	Oscar Project	projectoscar80@gmail.com	0791970956		Front Desk	Front Office	\N	350000.00	\N	Day	08:00:00	17:00:00	\N	\N	\N	2026-05-19	active	2026-05-19 21:10:01.602854	2026-05-21 22:52:45.50395
\.


--
-- Data for Name: staff_leave_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff_leave_requests (leave_id, staff_id, leave_type, start_date, end_date, reason, status, approved_by, approved_at, created_at) FROM stdin;
\.


--
-- Data for Name: staff_performance_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff_performance_reviews (review_id, staff_id, reviewer_id, review_date, rating, comments, goals, created_at) FROM stdin;
\.


--
-- Data for Name: system_reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_reports (report_id, report_name, report_type, generated_by, parameters, file_url, status, created_at) FROM stdin;
\.


--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_settings (setting_id, setting_key, setting_value, setting_group, description, updated_at) FROM stdin;
1	system_name	Rwanda Hotel Management System	general	System display name	2026-05-12 22:36:44.567525
2	system_email	support@rhms.gov.rw	general	System contact email	2026-05-12 22:36:44.567525
3	system_phone	+250 791 970 956	general	System contact phone	2026-05-12 22:36:44.567525
4	booking_cancellation_days	7	booking	Days before check-in for free cancellation	2026-05-12 22:36:44.567525
5	max_guests_per_room	4	booking	Maximum guests allowed per room	2026-05-12 22:36:44.567525
6	default_currency	RWF	financial	Default currency for transactions	2026-05-12 22:36:44.567525
7	tax_rate	18	financial	VAT tax rate percentage	2026-05-12 22:36:44.567525
8	maintenance_mode	false	system	System maintenance mode flag	2026-05-12 22:36:44.567525
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (task_id, assigned_to, assigned_by, title, description, priority, status, due_date, created_at, updated_at, completed_at) FROM stdin;
\.


--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_sessions (session_id, user_id, token, ip_address, user_agent, expires_at, created_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, full_name, email, phone, password_hash, role, is_verified, verification_code, verification_code_expires, reset_token, reset_token_expires, two_factor_enabled, two_factor_secret, profile_picture, last_login, is_active, created_at, updated_at) FROM stdin;
12	JEAND'AMOUR  NIYIGENA	jeandamourn82@gmail.com	0784492741	$2a$10$40augLtK34D73HwF4//9t.JpeNxNS8fOwJHc3sI0m4bkmEgX9ie/K	client	t	\N	\N	\N	\N	f	\N	data:image/jpeg;base64,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	2026-05-16 12:49:02.430564	t	2026-05-16 12:46:30.604031	2026-05-16 13:58:37.080877
5	Felix  Dufitimana	felixdufitimana@gmail.com	0795985533	$2a$10$TKX3uZI5TRZ76NHTQ3yZPuPmtrXqfyusGOAI9fFK15.w1ND9I/bOe	client	f	310851	2026-05-14 18:31:12.459	\N	\N	f	\N	\N	\N	t	2026-05-14 18:21:12.463512	2026-05-16 13:58:37.080877
15	Emelyne	computersciences2025@gmail.com	567483475	$2a$10$wvddkPLzNhj9NSIqjix/GecP/b9n6mPwDADh.kPwF7NFSitwlsRfe	hotel_admin	f	381220	2026-05-19 20:01:05.56	\N	\N	f	\N	\N	\N	t	2026-05-19 19:51:05.408265	2026-05-19 19:51:05.408265
14	Mr oscar Mr oscar hagenimana	ndatimanaizabayo00@gmail.com	567483947	$2a$10$uSFIKcJswa5munk59w1uv.7Sg9DtpqSSRni22CoB6Kp9zH/uEa2Du	hotel_admin	f	199220	2026-05-18 00:31:49.428	\N	\N	f	\N	\N	\N	t	2026-05-18 00:21:49.262364	2026-05-18 00:21:49.262364
13	Hagenimana Oscar	hagenimanaoscar4@gmail.com	567584930	$2a$10$wGWoV5VYGMlyaN9nYTSUGO9H.pRGNpQycuUKhZJwjv72/KGFYeDFC	hotel_admin	f	481747	2026-05-18 00:18:31.12	\N	\N	f	\N	\N	\N	t	2026-05-18 00:08:30.996732	2026-05-18 00:08:30.996732
2	Hagenimana Oscar	hagenimanaoscar43@gmail.com	782398790	$2a$10$UieBGrZDSLpOnj4tWbrd2eF3IGeQFue/6EDiz8l813mkgP2FzMWy.	hotel_admin	t	\N	\N	e70ad19c450694829c79d49e19c69730440afd861e1627387fcf2fe27eaf9c9b	2026-05-18 01:22:45.05	f	\N	\N	2026-05-21 22:25:03.867251	t	2026-05-13 08:48:38.483336	2026-05-21 22:25:03.867251
16	ingabire solange	projectoscar80@gmail.com	0791970956	$2a$10$W3ZlyPG.s8iONAhXFyOevOocGaiO6ALGZoY.FmnfVcCQN5gvgv4WG	employee	t	\N	\N	\N	\N	f	\N	\N	2026-05-21 22:49:06.523823	t	2026-05-19 21:10:01.602854	2026-05-21 22:49:06.523823
1	Lucie Niyonkuru	lucieniyonkuru46@gmail.com	0791970956	$2a$10$v6xdP2h0W.KZXITefa7EeuFa.BAN7y6IVcpYej/S1NUjQc//c3SIy	client	t	\N	\N	\N	\N	f	\N	data:image/jpeg;base64,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	2026-05-21 22:55:35.783026	t	2026-05-12 22:39:28.352706	2026-05-21 22:55:35.783026
11	RDB Administrator	admin@rdb.gov.rw	+250788000001	$2a$10$lww/y8MMliunr/JQm1h0Ru9aSPvyUZVzE9C4XxfhKvnXQD9L9xGJm	rdb	t	\N	\N	\N	\N	f	\N	\N	2026-05-22 01:39:02.346951	t	2026-05-14 22:10:04.389554	2026-05-22 01:39:02.346951
\.


--
-- Name: admin_activity_logs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_activity_logs_log_id_seq', 1, false);


--
-- Name: amenities_amenity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.amenities_amenity_id_seq', 15, true);


--
-- Name: announcement_recipients_recipient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.announcement_recipients_recipient_id_seq', 1, false);


--
-- Name: announcements_announcement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.announcements_announcement_id_seq', 4, true);


--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_attendance_id_seq', 178, true);


--
-- Name: bank_transfers_transfer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bank_transfers_transfer_id_seq', 1, false);


--
-- Name: booking_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.booking_history_history_id_seq', 1, false);


--
-- Name: bookings_booking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bookings_booking_id_seq', 3, true);


--
-- Name: chat_conversations_conversation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chat_conversations_conversation_id_seq', 1, false);


--
-- Name: chat_messages_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chat_messages_message_id_seq', 13, true);


--
-- Name: dice_rolls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dice_rolls_id_seq', 1, false);


--
-- Name: email_logs_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.email_logs_email_id_seq', 1, false);


--
-- Name: guest_reviews_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.guest_reviews_review_id_seq', 1, false);


--
-- Name: hotel_daily_metrics_metric_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hotel_daily_metrics_metric_id_seq', 1, false);


--
-- Name: hotel_documents_document_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hotel_documents_document_id_seq', 1, false);


--
-- Name: hotel_settings_setting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hotel_settings_setting_id_seq', 1, false);


--
-- Name: hotels_hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hotels_hotel_id_seq', 4, true);


--
-- Name: leave_balances_balance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leave_balances_balance_id_seq', 1, false);


--
-- Name: leaves_leave_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leaves_leave_id_seq', 1, false);


--
-- Name: messages_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.messages_message_id_seq', 1, false);


--
-- Name: mobile_money_transactions_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mobile_money_transactions_transaction_id_seq', 1, false);


--
-- Name: notifications_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_notification_id_seq', 2, true);


--
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 1, false);


--
-- Name: payroll_logs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payroll_logs_log_id_seq', 1, false);


--
-- Name: probability_analyses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.probability_analyses_id_seq', 1, false);


--
-- Name: push_tokens_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.push_tokens_token_id_seq', 1, false);


--
-- Name: rdb_admins_admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rdb_admins_admin_id_seq', 9, true);


--
-- Name: reports_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reports_report_id_seq', 1, false);


--
-- Name: room_images_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.room_images_image_id_seq', 1, false);


--
-- Name: room_pricing_seasons_pricing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.room_pricing_seasons_pricing_id_seq', 1, false);


--
-- Name: rooms_room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rooms_room_id_seq', 3, true);


--
-- Name: salary_records_salary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.salary_records_salary_id_seq', 3, true);


--
-- Name: simulation_batches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.simulation_batches_id_seq', 1, false);


--
-- Name: simulation_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.simulation_results_id_seq', 1, false);


--
-- Name: staff_leave_requests_leave_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staff_leave_requests_leave_id_seq', 1, false);


--
-- Name: staff_performance_reviews_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staff_performance_reviews_review_id_seq', 1, false);


--
-- Name: staff_staff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staff_staff_id_seq', 3, true);


--
-- Name: system_reports_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_reports_report_id_seq', 1, false);


--
-- Name: system_settings_setting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_settings_setting_id_seq', 8, true);


--
-- Name: tasks_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_task_id_seq', 1, false);


--
-- Name: user_sessions_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_sessions_session_id_seq', 1, false);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 17, true);


--
-- Name: admin_activity_logs admin_activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_activity_logs
    ADD CONSTRAINT admin_activity_logs_pkey PRIMARY KEY (log_id);


--
-- Name: amenities amenities_amenity_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amenities
    ADD CONSTRAINT amenities_amenity_name_key UNIQUE (amenity_name);


--
-- Name: amenities amenities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amenities
    ADD CONSTRAINT amenities_pkey PRIMARY KEY (amenity_id);


--
-- Name: announcement_recipients announcement_recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcement_recipients
    ADD CONSTRAINT announcement_recipients_pkey PRIMARY KEY (recipient_id);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (announcement_id);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (attendance_id);


--
-- Name: attendance attendance_staff_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_staff_id_date_key UNIQUE (staff_id, date);


--
-- Name: bank_transfers bank_transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_transfers
    ADD CONSTRAINT bank_transfers_pkey PRIMARY KEY (transfer_id);


--
-- Name: booking_history booking_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_history
    ADD CONSTRAINT booking_history_pkey PRIMARY KEY (history_id);


--
-- Name: bookings bookings_booking_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_booking_number_key UNIQUE (booking_number);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (booking_id);


--
-- Name: chat_conversations chat_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_conversations
    ADD CONSTRAINT chat_conversations_pkey PRIMARY KEY (conversation_id);


--
-- Name: chat_messages chat_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_pkey PRIMARY KEY (message_id);


--
-- Name: dice_rolls dice_rolls_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dice_rolls
    ADD CONSTRAINT dice_rolls_pkey PRIMARY KEY (id);


--
-- Name: email_logs email_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_logs
    ADD CONSTRAINT email_logs_pkey PRIMARY KEY (email_id);


--
-- Name: guest_reviews guest_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guest_reviews
    ADD CONSTRAINT guest_reviews_pkey PRIMARY KEY (review_id);


--
-- Name: hotel_daily_metrics hotel_daily_metrics_hotel_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_daily_metrics
    ADD CONSTRAINT hotel_daily_metrics_hotel_id_date_key UNIQUE (hotel_id, date);


--
-- Name: hotel_daily_metrics hotel_daily_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_daily_metrics
    ADD CONSTRAINT hotel_daily_metrics_pkey PRIMARY KEY (metric_id);


--
-- Name: hotel_documents hotel_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_documents
    ADD CONSTRAINT hotel_documents_pkey PRIMARY KEY (document_id);


--
-- Name: hotel_settings hotel_settings_hotel_id_setting_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_settings
    ADD CONSTRAINT hotel_settings_hotel_id_setting_key_key UNIQUE (hotel_id, setting_key);


--
-- Name: hotel_settings hotel_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_settings
    ADD CONSTRAINT hotel_settings_pkey PRIMARY KEY (setting_id);


--
-- Name: hotels hotels_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_email_key UNIQUE (email);


--
-- Name: hotels hotels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_pkey PRIMARY KEY (hotel_id);


--
-- Name: leave_balances leave_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT leave_balances_pkey PRIMARY KEY (balance_id);


--
-- Name: leave_balances leave_balances_staff_id_year_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT leave_balances_staff_id_year_key UNIQUE (staff_id, year);


--
-- Name: leaves leaves_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leaves
    ADD CONSTRAINT leaves_pkey PRIMARY KEY (leave_id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (message_id);


--
-- Name: mobile_money_transactions mobile_money_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mobile_money_transactions
    ADD CONSTRAINT mobile_money_transactions_pkey PRIMARY KEY (transaction_id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- Name: payroll_logs payroll_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payroll_logs
    ADD CONSTRAINT payroll_logs_pkey PRIMARY KEY (log_id);


--
-- Name: probability_analyses probability_analyses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.probability_analyses
    ADD CONSTRAINT probability_analyses_pkey PRIMARY KEY (id);


--
-- Name: push_tokens push_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.push_tokens
    ADD CONSTRAINT push_tokens_pkey PRIMARY KEY (token_id);


--
-- Name: rdb_admins rdb_admins_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rdb_admins
    ADD CONSTRAINT rdb_admins_email_key UNIQUE (email);


--
-- Name: rdb_admins rdb_admins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rdb_admins
    ADD CONSTRAINT rdb_admins_pkey PRIMARY KEY (admin_id);


--
-- Name: rdb_admins rdb_admins_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rdb_admins
    ADD CONSTRAINT rdb_admins_username_key UNIQUE (username);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (report_id);


--
-- Name: room_images room_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room_images
    ADD CONSTRAINT room_images_pkey PRIMARY KEY (image_id);


--
-- Name: room_pricing_seasons room_pricing_seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room_pricing_seasons
    ADD CONSTRAINT room_pricing_seasons_pkey PRIMARY KEY (pricing_id);


--
-- Name: rooms rooms_hotel_id_room_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_hotel_id_room_number_key UNIQUE (hotel_id, room_number);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (room_id);


--
-- Name: salary_records salary_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salary_records
    ADD CONSTRAINT salary_records_pkey PRIMARY KEY (salary_id);


--
-- Name: salary_records salary_records_staff_id_month_year_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salary_records
    ADD CONSTRAINT salary_records_staff_id_month_year_key UNIQUE (staff_id, month, year);


--
-- Name: simulation_batches simulation_batches_batch_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.simulation_batches
    ADD CONSTRAINT simulation_batches_batch_id_key UNIQUE (batch_id);


--
-- Name: simulation_batches simulation_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.simulation_batches
    ADD CONSTRAINT simulation_batches_pkey PRIMARY KEY (id);


--
-- Name: simulation_results simulation_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.simulation_results
    ADD CONSTRAINT simulation_results_pkey PRIMARY KEY (id);


--
-- Name: staff staff_hotel_id_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_hotel_id_email_key UNIQUE (hotel_id, email);


--
-- Name: staff_leave_requests staff_leave_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_leave_requests
    ADD CONSTRAINT staff_leave_requests_pkey PRIMARY KEY (leave_id);


--
-- Name: staff_performance_reviews staff_performance_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_performance_reviews
    ADD CONSTRAINT staff_performance_reviews_pkey PRIMARY KEY (review_id);


--
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (staff_id);


--
-- Name: system_reports system_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_reports
    ADD CONSTRAINT system_reports_pkey PRIMARY KEY (report_id);


--
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (setting_id);


--
-- Name: system_settings system_settings_setting_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_setting_key_key UNIQUE (setting_key);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (task_id);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (session_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: idx_analysis_concept; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_analysis_concept ON public.probability_analyses USING btree (concept_name);


--
-- Name: idx_announcements_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_announcements_created_at ON public.announcements USING btree (created_at DESC);


--
-- Name: idx_bookings_check_in_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_check_in_date ON public.bookings USING btree (check_in_date);


--
-- Name: idx_bookings_hotel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_hotel_id ON public.bookings USING btree (hotel_id);


--
-- Name: idx_bookings_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_status ON public.bookings USING btree (status);


--
-- Name: idx_bookings_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_user_id ON public.bookings USING btree (user_id);


--
-- Name: idx_chat_messages_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_chat_messages_created ON public.chat_messages USING btree (created_at DESC);


--
-- Name: idx_chat_messages_receiver; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_chat_messages_receiver ON public.chat_messages USING btree (receiver_id);


--
-- Name: idx_chat_messages_sender; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_chat_messages_sender ON public.chat_messages USING btree (sender_id);


--
-- Name: idx_chat_messages_users; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_chat_messages_users ON public.chat_messages USING btree (sender_id, receiver_id);


--
-- Name: idx_concept_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_concept_name ON public.simulation_results USING btree (concept_name);


--
-- Name: idx_hotels_city; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hotels_city ON public.hotels USING btree (city);


--
-- Name: idx_hotels_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hotels_name ON public.hotels USING btree (hotel_name);


--
-- Name: idx_hotels_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hotels_status ON public.hotels USING btree (status);


--
-- Name: idx_hotels_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hotels_user_id ON public.hotels USING btree (user_id);


--
-- Name: idx_messages_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_created_at ON public.messages USING btree (created_at DESC);


--
-- Name: idx_messages_receiver_read; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_receiver_read ON public.messages USING btree (receiver_id, is_read);


--
-- Name: idx_messages_sender_receiver; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_sender_receiver ON public.messages USING btree (sender_id, receiver_id);


--
-- Name: idx_notifications_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_created_at ON public.notifications USING btree (created_at DESC);


--
-- Name: idx_notifications_hotel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_hotel_id ON public.notifications USING btree (hotel_id);


--
-- Name: idx_roll_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_roll_value ON public.dice_rolls USING btree (roll_value);


--
-- Name: idx_rooms_hotel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rooms_hotel_id ON public.rooms USING btree (hotel_id);


--
-- Name: idx_rooms_room_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rooms_room_type ON public.rooms USING btree (room_type);


--
-- Name: idx_rooms_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rooms_status ON public.rooms USING btree (status);


--
-- Name: idx_salary_records_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_salary_records_date ON public.salary_records USING btree (year, month);


--
-- Name: idx_salary_records_staff; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_salary_records_staff ON public.salary_records USING btree (staff_id);


--
-- Name: idx_salary_records_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_salary_records_status ON public.salary_records USING btree (status);


--
-- Name: idx_session_rolls; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_session_rolls ON public.dice_rolls USING btree (session_id, "timestamp");


--
-- Name: idx_tasks_assigned_to; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasks_assigned_to ON public.tasks USING btree (assigned_to);


--
-- Name: idx_tasks_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasks_status ON public.tasks USING btree (status);


--
-- Name: idx_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_timestamp ON public.simulation_results USING btree ("timestamp");


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_is_verified; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_is_verified ON public.users USING btree (is_verified);


--
-- Name: idx_users_reset_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_reset_token ON public.users USING btree (reset_token);


--
-- Name: idx_users_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_role ON public.users USING btree (role);


--
-- Name: bookings update_bookings_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_bookings_updated_at BEFORE UPDATE ON public.bookings FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: chat_conversations update_chat_conversations_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_chat_conversations_updated_at BEFORE UPDATE ON public.chat_conversations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: hotels update_hotels_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_hotels_updated_at BEFORE UPDATE ON public.hotels FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: leave_balances update_leave_balances_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_leave_balances_updated_at BEFORE UPDATE ON public.leave_balances FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: rdb_admins update_rdb_admins_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_rdb_admins_updated_at BEFORE UPDATE ON public.rdb_admins FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: rooms update_rooms_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_rooms_updated_at BEFORE UPDATE ON public.rooms FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: staff update_staff_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_staff_updated_at BEFORE UPDATE ON public.staff FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: admin_activity_logs admin_activity_logs_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_activity_logs
    ADD CONSTRAINT admin_activity_logs_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.rdb_admins(admin_id) ON DELETE CASCADE;


--
-- Name: announcement_recipients announcement_recipients_announcement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcement_recipients
    ADD CONSTRAINT announcement_recipients_announcement_id_fkey FOREIGN KEY (announcement_id) REFERENCES public.announcements(announcement_id) ON DELETE CASCADE;


--
-- Name: announcement_recipients announcement_recipients_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcement_recipients
    ADD CONSTRAINT announcement_recipients_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: attendance attendance_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id) ON DELETE CASCADE;


--
-- Name: bank_transfers bank_transfers_confirmed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_transfers
    ADD CONSTRAINT bank_transfers_confirmed_by_fkey FOREIGN KEY (confirmed_by) REFERENCES public.users(user_id);


--
-- Name: bank_transfers bank_transfers_payment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_transfers
    ADD CONSTRAINT bank_transfers_payment_id_fkey FOREIGN KEY (payment_id) REFERENCES public.payments(payment_id) ON DELETE CASCADE;


--
-- Name: booking_history booking_history_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_history
    ADD CONSTRAINT booking_history_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(booking_id) ON DELETE CASCADE;


--
-- Name: booking_history booking_history_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_history
    ADD CONSTRAINT booking_history_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(user_id);


--
-- Name: bookings bookings_cancelled_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_cancelled_by_fkey FOREIGN KEY (cancelled_by) REFERENCES public.users(user_id);


--
-- Name: bookings bookings_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE CASCADE;


--
-- Name: bookings bookings_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(room_id) ON DELETE SET NULL;


--
-- Name: bookings bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: chat_conversations chat_conversations_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_conversations
    ADD CONSTRAINT chat_conversations_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id);


--
-- Name: chat_conversations chat_conversations_participant1_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_conversations
    ADD CONSTRAINT chat_conversations_participant1_id_fkey FOREIGN KEY (participant1_id) REFERENCES public.users(user_id);


--
-- Name: chat_conversations chat_conversations_participant2_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_conversations
    ADD CONSTRAINT chat_conversations_participant2_id_fkey FOREIGN KEY (participant2_id) REFERENCES public.users(user_id);


--
-- Name: chat_messages chat_messages_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE CASCADE;


--
-- Name: chat_messages chat_messages_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: chat_messages chat_messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: email_logs email_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_logs
    ADD CONSTRAINT email_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: notifications fk_notifications_hotel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_notifications_hotel FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE CASCADE;


--
-- Name: guest_reviews guest_reviews_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guest_reviews
    ADD CONSTRAINT guest_reviews_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(booking_id) ON DELETE CASCADE;


--
-- Name: guest_reviews guest_reviews_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guest_reviews
    ADD CONSTRAINT guest_reviews_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE CASCADE;


--
-- Name: guest_reviews guest_reviews_response_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guest_reviews
    ADD CONSTRAINT guest_reviews_response_by_fkey FOREIGN KEY (response_by) REFERENCES public.users(user_id);


--
-- Name: guest_reviews guest_reviews_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guest_reviews
    ADD CONSTRAINT guest_reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: hotel_daily_metrics hotel_daily_metrics_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_daily_metrics
    ADD CONSTRAINT hotel_daily_metrics_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE CASCADE;


--
-- Name: hotel_documents hotel_documents_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_documents
    ADD CONSTRAINT hotel_documents_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE CASCADE;


--
-- Name: hotel_settings hotel_settings_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_settings
    ADD CONSTRAINT hotel_settings_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE CASCADE;


--
-- Name: hotels hotels_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(user_id);


--
-- Name: hotels hotels_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: leave_balances leave_balances_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT leave_balances_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id) ON DELETE CASCADE;


--
-- Name: leaves leaves_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leaves
    ADD CONSTRAINT leaves_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(user_id);


--
-- Name: leaves leaves_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leaves
    ADD CONSTRAINT leaves_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id) ON DELETE CASCADE;


--
-- Name: messages messages_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: messages messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: mobile_money_transactions mobile_money_transactions_payment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mobile_money_transactions
    ADD CONSTRAINT mobile_money_transactions_payment_id_fkey FOREIGN KEY (payment_id) REFERENCES public.payments(payment_id) ON DELETE CASCADE;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: payments payments_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(booking_id) ON DELETE CASCADE;


--
-- Name: payments payments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: payroll_logs payroll_logs_processed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payroll_logs
    ADD CONSTRAINT payroll_logs_processed_by_fkey FOREIGN KEY (processed_by) REFERENCES public.users(user_id);


--
-- Name: push_tokens push_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.push_tokens
    ADD CONSTRAINT push_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: rdb_admins rdb_admins_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rdb_admins
    ADD CONSTRAINT rdb_admins_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: reports reports_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id);


--
-- Name: room_images room_images_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room_images
    ADD CONSTRAINT room_images_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(room_id) ON DELETE CASCADE;


--
-- Name: room_pricing_seasons room_pricing_seasons_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room_pricing_seasons
    ADD CONSTRAINT room_pricing_seasons_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(room_id) ON DELETE CASCADE;


--
-- Name: rooms rooms_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE CASCADE;


--
-- Name: salary_records salary_records_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salary_records
    ADD CONSTRAINT salary_records_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id) ON DELETE CASCADE;


--
-- Name: staff staff_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE CASCADE;


--
-- Name: staff_leave_requests staff_leave_requests_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_leave_requests
    ADD CONSTRAINT staff_leave_requests_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(user_id);


--
-- Name: staff_leave_requests staff_leave_requests_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_leave_requests
    ADD CONSTRAINT staff_leave_requests_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id) ON DELETE CASCADE;


--
-- Name: staff_performance_reviews staff_performance_reviews_reviewer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_performance_reviews
    ADD CONSTRAINT staff_performance_reviews_reviewer_id_fkey FOREIGN KEY (reviewer_id) REFERENCES public.users(user_id);


--
-- Name: staff_performance_reviews staff_performance_reviews_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_performance_reviews
    ADD CONSTRAINT staff_performance_reviews_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id) ON DELETE CASCADE;


--
-- Name: staff staff_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: system_reports system_reports_generated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_reports
    ADD CONSTRAINT system_reports_generated_by_fkey FOREIGN KEY (generated_by) REFERENCES public.users(user_id);


--
-- Name: tasks tasks_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(user_id);


--
-- Name: tasks tasks_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(user_id);


--
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict bcc3yDr77oZYv0EmWhKAMfy2joh6V0OS9NMi0Uh7evBezlowq1AkqzwmEjW9RZe

