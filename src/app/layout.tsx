import type { Metadata } from "next";
import "./globals.css";
import { Space_Mono, Space_Grotesk } from 'next/font/google'
 
// const inter = Inter({
//   subsets: ['latin'],
//   display: 'swap',
//   variable: '--font-inter',
// })
 
// const roboto_mono = Roboto_Mono({
//   subsets: ['latin'],
//   display: 'swap',
//   variable: '--font-roboto-mono',
// })

// const geist_sans = Space_Mono({
//   weight: "700",
//   subsets: ['latin'],
//   display: 'swap',
//   variable: '--font-space-mono',
// })
const space_sans = Space_Grotesk({
  weight: "700",
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-space-grotesk',
})

const space_mono = Space_Mono({
  weight: "700",
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-space-mono',
})

export const metadata: Metadata = {
  title: "CCIP-ICM",
  description: "Generated at a Crossroads under a pale moonlight.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body
        className={`
            ${space_sans.variable} 
            ${space_mono.variable} 
          antialiased
          `}
      >
        {children}
      </body>
    </html>
  );
}
