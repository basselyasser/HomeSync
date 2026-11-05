const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

// Use your email details for sending
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "your-email@gmail.com",
    pass: "your-email-password",
  },
});

exports.sendOtpEmail = functions.https.onCall(async (data, context) => {
  const email = data.email;
  const otp = Math.floor(100000 + Math.random() * 900000); // 6 digit OTP

  // Save OTP to Firestore or Realtime Database (optional)
  await admin.firestore().collection("otp_verification").doc(email).set({otp});

  // Send OTP email
  const mailOptions = {
    from: "your-email@gmail.com",
    to: email,
    subject: "Your OTP for Registration",
    text: `Your OTP for registration is: ${otp}`,
  };

  try {
    await transporter.sendMail(mailOptions);
    return {message: "OTP sent to email"};
  } catch (error) {
    throw new functions.https.HttpsError(
        "unknown",
        "Error sending OTP email",
        error,
    );
  }
});
